class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :set_service, only: %i[ index new ]

  def index
    @page = params[:page].to_i.abs

    if current_user.owns? @service
      events = @service.events.booked.where(date: Date.today..)
    else
      events = current_user.events.includes(:payment).booked.where(date: Date.today..)
           .or(current_user.events.includes(:payment).where('payments.status' => 'pending')
           .booked.where(date: ...Date.yesterday))
    end

    @events = events.includes(:slot_rule).order(:date, "slot_rules.time").limit(10).offset(10*(@page))
  end

  def show
  end

  def new
    slot_rule = @service.slot_rules.find(params[:rule_id])

    @event = current_user.events.new(
      slot_rule: slot_rule,
      date: params[:service_time_zone_date]
    )
  end

  def edit
  end

  def create
    # TODO: tidy up fat controller!
    if params.dig(:event, :user_attributes, :email).presence
      @event = Event.new(user_event_params)

      if user = User.find_by(email: params.dig(:event, :user_attributes, :email))
        @event.user = user
      else
        @event.user.password = @event.user.password_confirmation = SecureRandom.hex(6)
      end
    else
      @event = current_user.events.new(event_params)
      @event.name = params.dig(:event, :user_attributes, :name)
    end

    if @event.save
      recurrence = params[:event][:recurrence]
      if recurrence == "weekly" || recurrence == "biweekly"
        @event_rule = @event.user.event_rules.create!(event_rule_params)
        @event_rule.create_events_from(@event)

        notice = "Cita #{t('activerecord.attributes.event_rule.recurrences.' + @event_rule&.recurrence)} creada éxitosamente"
      end
      notice ||= @event.blocked? ? t(:event_blocked) : t(:event_created)

      EventMailer.with(event: @event).created_email.deliver_later if @event.booked?
      EventMailer.with(event: @event).confirmation_email.deliver_later if @event.booked? && !@event.user.owns?(@event.service)

      redirect_to event_url(@event), notice:
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    respond_to do |format|
      if @event.update(event_params)
        format.html { redirect_to event_url(@event), notice: "Event was successfully updated." }
        format.json { render :show, status: :ok, location: @event }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @event.past?
      redirect_to service_slots_url(@event.service), alert: "Citas pasadas no pueden ser modificadas"
    else
      @event.destroy

      if event_rule_id = params[:destroy_event_rule]
        event_rule = EventRule.find(event_rule_id)
        if current_user == event_rule.user || current_user == event_rule.service.user
          event_rule.destroy
          Event.where(slot_rule: @event.slot_rule, user: @event.user, date: @event.date..).destroy_all

          notice = "Citas recurrentes anuladas éxitosamente"
        end
      else
        notice = @event.blocked? ? t(:event_unblocked) : t(:event_canceled)
      end

      # EventMailer.with(event: @event).destroyed_email.deliver_later if @event.booked?
      redirect_to service_slots_url(@event.service), notice:
    end
  end

  private

    def set_event
      @event = Event.find(params[:id])
      redirect_to service_slots_path(event.service) unless current_user == @event.user ||
                                                           current_user == @event.service.user 
    end

    def set_service
      @service = Service.find params[:service_id]
      session[:service_id] = @service.id
      session[:locale] = @service.locale
    end

    def event_params
      params.require(:event).permit(:status, :slot_rule_id, :date, :comment)
    end

    def user_event_params
      params.require(:event).permit(:status, :slot_rule_id, :date, user_attributes: [:name, :email, :phone, :time_zone])
    end

    def event_rule_params
      params.require(:event).permit(:slot_rule_id, :date, :recurrence)
    end
end

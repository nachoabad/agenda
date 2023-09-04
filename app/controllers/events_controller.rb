class EventsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_event, only: %i[ show edit update destroy ]
  before_action :set_service, only: %i[ index new ]

  def index
    if current_user.owns? @service
      events = @service.events.booked.where(date: Date.today..)
    else
      events = current_user.events.includes(:payment).booked.where(date: Date.today..)
           .or(current_user.events.includes(:payment).where('payments.status' => 'pending')
           .booked.where(date: ...Date.yesterday))
    end

    @events = events.includes(:slot_rule).order(:date, "slot_rules.time")
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
    @event = current_user.events.new(event_params)

    if @event.save
      EventMailer.with(event: @event).created_email.deliver_later if @event.booked?
      notice = @event.blocked? ? "Cita bloqueada éxitosamente" : "Cita creada éxitosamente"
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
      notice = @event.blocked? ? "Cita desbloqueada éxitosamente" : "Cita anulada éxitosamente"
      redirect_to service_slots_url(@event.service), notice:
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_event
      @event = Event.find(params[:id])
      redirect_to service_slots_path(event.service) unless current_user == @event.user ||
                                                           current_user == @event.service.user 
    end

    def set_service
      @service = Service.find params[:service_id]
      session[:service_id] = @service.id
    end

    # Only allow a list of trusted parameters through.
    def event_params
      params.require(:event).permit(:status, :slot_rule_id, :date)
    end
end

class PaymentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_payment, only: %i[ show edit update destroy ]

  def index
    @service = current_user.services.first
    @payments = @service.payments.not_confirmed.past
  end

  def edit
  end

  def update
    if @payment.update(payment_params)
      redirect_to edit_payment_url(@payment),
        notice: "Pago éxitosamente #{@payment.confirmed? ? 'confirmado' : 'reportado' }"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private
    def set_payment
      @payment = Payment.find(params[:id])
      redirect_to service_slots_path(event.service) unless (current_user == @payment.event.user && !@payment.confirmed?) ||
                                                            current_user == @payment.service.user
    end

    def payment_params
      params.require(:payment).permit(:status, :date, :amount, :currency, :reference, :event_id, :comments)
    end
end

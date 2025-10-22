class AppointmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_appointment, only: %i[ show edit update destroy complete ] 

  # GET /appointments or /appointments.json
  def index
    @appointments = Appointment.includes(:user, :hub).order(appointment_date: :desc) # Começa com todos, ordenados

    if params[:search_id].present?
      @appointments = @appointments.where(id: params[:search_id])
    end

    if params[:search_date].present?
      begin
        # Tenta converter a data
        search_date = Date.parse(params[:search_date])
        # Filtra por agendamentos daquele dia (do início ao fim do dia)
        @appointments = @appointments.where(appointment_date: search_date.all_day)
      rescue Date::Error
        # Se a data for inválida, não faz nada (ou você pode adicionar um flash message)
      end
    end
  end

  # GET /appointments/1 or /appointments/1.json
  def show
  end

  # GET /appointments/new
  def new
    @appointment = Appointment.new
    @appointment.technician_name = "Florence Nightingale"
    @appointment.appointment_items.build
  end

  # GET /appointments/1/edit
  def edit
    @appointment.appointment_items.build if @appointment.appointment_items.empty?
  end

  # POST /appointments or /appointments.json
  def create
    @appointment = Appointment.new(appointment_params)
    @appointment.user = current_user

    if @appointment.save
      redirect_to @appointment, notice: "Agendamento criado com sucesso."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /appointments/1
  def update
    if @appointment.update(appointment_params)
      redirect_to @appointment, notice: "Agendamento atualizado com sucesso."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /appointments/1 or /appointments/1.json
  def destroy
    @appointment.destroy
    redirect_to appointments_url, notice: "Agendamento destruído com sucesso."
  end

  def complete
    ActiveRecord::Base.transaction do
      @appointment.appointment_items.each do |item_agendado|
        stock_item = @appointment.hub.stock_items.find_by(product_id: item_agendado.product_id)

        if stock_item && stock_item.quantity >= item_agendado.quantity
          stock_item.quantity -= item_agendado.quantity
          stock_item.save!
        else
          raise ActiveRecord::Rollback, "Estoque insuficiente para o produto #{item_agendado.product.name}"
        end
      end

      @appointment.update!(status: "Concluído")
    end
    
    redirect_to @appointment, notice: "Agendamento concluído e estoque atualizado!"
  
  rescue ActiveRecord::Rollback => e
    redirect_to @appointment, alert: "Erro ao concluir: #{e.message}"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_appointment
      @appointment = Appointment.includes(appointment_items: :product).find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def appointment_params
    params.require(:appointment).permit(
      :patient_name, 
      :appointment_date, 
      :address, 
      :status, 
      :technician_name, 
      :hub_id,
      # Não permitimos :user_id (será pego do current_user)
      appointment_items_attributes: [:id, :product_id, :quantity, :_destroy]
    )
  end
end

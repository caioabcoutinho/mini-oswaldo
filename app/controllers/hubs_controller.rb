class HubsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_hub, only: %i[ show edit update destroy ]

  # GET /hubs or /hubs.json
  def index
    @hubs = Hub.all
  end

  # GET /hubs/1 or /hubs/1.json
  def show
    @stock_items = @hub.stock_items.includes(:product)
  end

  # GET /hubs/new
  def new
    @hub = Hub.new
  end

  # GET /hubs/1/edit
  def edit
  end

  # POST /hubs or /hubs.json
  def create
    @hub = Hub.new(hub_params)

    respond_to do |format|
      if @hub.save
        format.html { redirect_to @hub, notice: "Hub was successfully created." }
        format.json { render :show, status: :created, location: @hub }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @hub.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hubs/1 or /hubs/1.json
  def update
    respond_to do |format|
      if @hub.update(hub_params)
        format.html { redirect_to @hub, notice: "Hub was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @hub }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @hub.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hubs/1 or /hubs/1.json
  def destroy
    if @hub.destroy
      redirect_to hubs_path, notice: "Hub was successfully destroyed.", status: :see_other
    else
      redirect_to @hub, alert: @hub.errors.full_messages.to_sentence
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hub
      @hub = Hub.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def hub_params
      params.require(:hub).permit(:name, :location)
    end
end

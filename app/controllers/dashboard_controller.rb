class DashboardController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @total_products = Product.count
    @total_hubs = Hub.count
    @total_categories = Category.count
  
    @total_revenue = Appointment.
                      where(status: "Concluído").
                      joins(appointment_items: :product).
                      sum("appointment_items.quantity * products.price")
  end
end
class Appointment < ApplicationRecord
  belongs_to :user 
  belongs_to :hub
  has_many :appointment_items, dependent: :destroy
  has_many :products, through: :appointment_items
  accepts_nested_attributes_for :appointment_items, allow_destroy: true

  validate :check_stock_availability

  private

  def check_stock_availability
    return unless hub.present?

    appointment_items.each do |item|
      next unless item.product_id.present? && item.quantity.present? && item.quantity > 0

      stock_item = hub.stock_items.find_by(product_id: item.product_id)

      if stock_item.nil?
        errors.add(:base, "Estoque indisponível para #{item.product.name_with_category} no Hub #{hub.name}.")
      elsif stock_item.quantity < item.quantity
        errors.add(:base, "Estoque insuficiente para #{item.product.name_with_category}. " \
                          "Pedido: #{item.quantity}, Disponível: #{stock_item.quantity}.")
      end
    end
  end
end


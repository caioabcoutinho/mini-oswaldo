class Product < ApplicationRecord
  belongs_to :category
  has_many :stock_items, dependent: :destroy
  has_many :hubs, through: :stock_items

  def name_with_category
    "#{name} (#{category.name})"
  end
end
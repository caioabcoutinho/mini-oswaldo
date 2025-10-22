class Hub < ApplicationRecord
  has_many :stock_items, dependent: :destroy
  has_many :orders, through: :stock_items
end

class AddCascadeDeleteToStockItemsForeignKeys < ActiveRecord::Migration[8.0]
  def change
    # Remove FKs se existirem
    remove_foreign_key :stock_items, :products if foreign_key_exists?(:stock_items, :products)
    remove_foreign_key :stock_items, :hubs if foreign_key_exists?(:stock_items, :hubs)

    # Adiciona FKs com cascade on delete
    add_foreign_key :stock_items, :products, on_delete: :cascade
    add_foreign_key :stock_items, :hubs, on_delete: :cascade
  end
end
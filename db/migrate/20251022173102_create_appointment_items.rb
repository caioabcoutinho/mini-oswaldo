class CreateAppointmentItems < ActiveRecord::Migration[8.0]
  def change
    create_table :appointment_items do |t|
      t.references :appointment, null: false, foreign_key: true
      t.references :product, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end

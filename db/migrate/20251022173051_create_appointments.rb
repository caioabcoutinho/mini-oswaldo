class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.string :patient_name
      t.datetime :appointment_date
      t.text :address
      t.string :status
      t.string :technician_name
      t.references :hub, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end

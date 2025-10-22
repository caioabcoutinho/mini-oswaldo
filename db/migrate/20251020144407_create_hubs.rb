class CreateHubs < ActiveRecord::Migration[8.0]
  def change
    create_table :hubs do |t|
      t.string :name
      t.string :location

      t.timestamps
    end
  end
end

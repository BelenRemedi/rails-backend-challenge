class CreateAppointments < ActiveRecord::Migration[8.0]
  def change
    create_table :appointments do |t|
      t.integer :status, null: false, default: 0
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.references :provider, null: false, foreign_key: true
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end

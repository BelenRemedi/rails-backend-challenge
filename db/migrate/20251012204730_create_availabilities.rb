class CreateAvailabilities < ActiveRecord::Migration[8.0]
  def change
    create_table :availabilities do |t|
      t.string :source, null: false, default: "calendly"
      t.string :external_id, null: false
      t.time :start_time, null: false
      t.time :end_time, null: false
      t.integer :end_dow, null: false
      t.integer :start_dow, null: false
      t.references :provider, null: false, foreign_key: true

      t.index [ :provider_id, :source, :external_id ], unique: true

      t.timestamps
    end
  end
end

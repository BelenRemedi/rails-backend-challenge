class CreateProviders < ActiveRecord::Migration[8.0]
  def change
    create_table :providers do |t|
      t.string :external_id, null: false
      t.string :source, null: false, default: "calendly"

      t.index [ :source, :external_id ], unique: true
      t.timestamps
    end
  end
end

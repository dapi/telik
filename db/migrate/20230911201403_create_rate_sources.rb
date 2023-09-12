class CreateRateSources < ActiveRecord::Migration[7.0]
  def change
    create_table :rate_sources do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :rate_sources, :name, unique: true
  end
end

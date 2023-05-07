class CreateVisitors < ActiveRecord::Migration[7.0]
  def change
    create_table :visitors do |t|
      t.string :cookie_id, null: false
      t.timestamps
    end

    add_index :visitors, :cookie_id, unique: true
  end
end

class AddTelegramIdToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :telegram_id, :bigint, null: false
    add_column :users, :telegram_data, :jsonb, null: false, default: {}
    add_index :users, :telegram_id, unique: true
  end
end

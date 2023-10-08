class RemoveTelegramDataFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :telegram_data
  end
end

class RenameTelegramIdToTelegramUserIdInUsers < ActiveRecord::Migration[7.0]
  def change
    rename_column :users, :telegram_id, :telegram_user_id
  end
end

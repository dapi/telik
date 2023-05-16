class RemoveNullifyFromTelegramUser < ActiveRecord::Migration[7.0]
  def change
    change_column_null :visitors, :telegram_user_id, false
  end
end

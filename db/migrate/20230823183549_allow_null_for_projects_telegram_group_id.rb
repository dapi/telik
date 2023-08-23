class AllowNullForProjectsTelegramGroupId < ActiveRecord::Migration[7.0]
  def change
    change_column_null :projects, :telegram_group_id, true
  end
end

class AddTelegramGroupIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :telegram_group_id, :bigint
  end
end

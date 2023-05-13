class AddTelegramChatToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :telegram_chat, :jsonb
    add_column :projects, :telegram_group_is_forum, :boolean
  end
end

class AddBotStatusToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :bot_status, :string
    add_column :projects, :bot_can_manage_topics, :boolean
  end
end

class AddBotIdToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :bot_id, :string
    Project.find_each do |project|
      project.update! bot_id: project.fetch_bot_id.presence || ApplicationConfig.bot_id
    end
    change_column_null :projects, :bot_id, false
  end
end

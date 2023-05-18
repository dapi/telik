class AddBotTokenToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :bot_token, :string
    add_column :projects, :bot_username, :string
  end
end

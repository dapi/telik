class AddTelegramGroupNameToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :telegram_group_name, :string
    execute 'update projects set telegram_group_name = name'
  end
end

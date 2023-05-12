class AddUniquenessToProjectTelegramGroupId < ActiveRecord::Migration[7.0]
  def change
    Project.destroy_all
    add_index :projects, :telegram_group_id, unique: true
    change_column_null :projects, :telegram_group_id, false
  end
end

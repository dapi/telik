class AddUserDataToVisits < ActiveRecord::Migration[7.0]
  def change
    add_column :visits, :user_data, :jsonb, null: false, default: {}
    add_column :visits, :visit_data, :jsonb, null: false, default: {}
    rename_column :visits, :data, :page_data
  end
end

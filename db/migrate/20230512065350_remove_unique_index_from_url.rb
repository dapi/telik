class RemoveUniqueIndexFromUrl < ActiveRecord::Migration[7.0]
  def change
    remove_index :projects, name: "index_projects_on_url_and_owner_id"
    change_column_null :projects, :url, true
    add_column :projects, :custom_username, :string
    change_column_null :projects, :name, false
  end
end

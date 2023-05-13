class AddLastErrorToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :last_error, :string
    add_column :projects, :last_error_at, :timestamp
  end
end

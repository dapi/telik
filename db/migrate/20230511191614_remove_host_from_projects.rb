class RemoveHostFromProjects < ActiveRecord::Migration[7.0]
  def change
    remove_column :projects, :host
  end
end

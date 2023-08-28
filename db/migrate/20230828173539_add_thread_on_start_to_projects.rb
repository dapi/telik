class AddThreadOnStartToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :thread_on_start, :boolean, null: false, default: true
  end
end

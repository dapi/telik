class AddSkipWidgetAtToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :skip_widget_at, :timestamp
  end
end

class AddSkipThreadIdsToProjects < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :skip_threads_ids, :jsonb, null: false, default: []
  end
end

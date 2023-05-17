class AddTopicTemplateTagsToVisitors < ActiveRecord::Migration[7.0]
  def change
    add_column :projects, :topic_title_template, :string, null: true
  end
end

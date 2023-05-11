class AddTopicDataToVisitors < ActiveRecord::Migration[7.0]
  def change
    add_column :visitors, :topic_data, :jsonb
    remove_column :visitors, :cached_telegram_topic_name
    remove_column :visitors, :cached_telegram_topic_icon_color
  end
end

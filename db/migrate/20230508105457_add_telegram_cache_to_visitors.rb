class AddTelegramCacheToVisitors < ActiveRecord::Migration[7.0]
  def change
    add_column :visitors, :telegram_message_thread_id, :bigint
    add_column :visitors, :cached_telegram_topic_name, :string
    add_column :visitors, :cached_telegram_topic_icon_color, :bigint
    add_column :visitors, :telegram_cached_at, :timestamp
  end
end

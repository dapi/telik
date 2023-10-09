class CreateTelegramEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :telegram_events do |t|
      t.jsonb :payload, null: false

      t.timestamps
    end
  end
end

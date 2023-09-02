class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.bigint :message_id, null: false
      t.bigint :chat_id, null: false
      t.jsonb :payload, null: false
      t.boolean :from_telegram, null: false

      t.timestamps
    end

    add_index :messages, %i[chat_id message_id], unique: true
  end
end

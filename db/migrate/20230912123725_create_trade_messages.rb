class CreateTradeMessages < ActiveRecord::Migration[7.0]
  def change
    create_enum :chat_type, %i[trade taker_arbitr maker_arbitr]
    create_enum :author_type, %i[taker maker arbitr]
    create_table :trade_messages do |t|
      t.references :trade, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :content, null: false
      t.enum :chat_type, null: false, enum_type: :chat_type
      t.enum :author_type, null: false, enum_type: :author_type

      t.timestamps
    end
  end
end

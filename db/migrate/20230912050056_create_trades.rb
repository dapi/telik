class CreateTrades < ActiveRecord::Migration[7.0]
  def change
    create_enum :trade_type, %i[proposed wait_for_payment rejected_by_maker rejected_by_taker wait_for_delivery delivery_confirmed canceled]
    create_table :trades do |t|
      t.references :advert, null: false, foreign_key: true
      t.references :taker, null: false, foreign_key: { to_table: :users }
      t.enum :state, enum_type: :trade_type, null: false
      t.decimal :comission_amount, null: false
      t.decimal :comission_percent, null: false
      t.references :comission_currency, null: false, foreign_key: { to_table: :currencies }, type: :string, limit: 8

      t.decimal :good_amount, null: false, comment: 'Сколько товара покупает/продает клиент (taker)'
      t.references :good_currency, null: false, foreign_key: { to_table: :currencies }, type: :string, limit: 8

      t.decimal :payment_amount, null: false, comment: 'Сколько клиент платит/получает за купленный/проданный товар'
      t.references :payment_currency, null: false, foreign_key: { to_table: :currencies }, type: :string, limit: 8
      t.enum :rate_type, null: false, enum_type: :rate_type
      t.decimal :rate_percent
      t.decimal :rate_price, null: false
      t.references :rate_source, foreign_key: true
      t.text :advert_details, null: false
      t.jsonb :history, null: false, default: []
      t.timestamp :accepted_at
      t.jsonb :advert_dump, null: false, default: {}

      t.timestamps
    end

    add_column
  end
end

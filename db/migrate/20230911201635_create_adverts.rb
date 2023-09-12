class CreateAdverts < ActiveRecord::Migration[7.0]
  def change
    create_enum :advert_type, %i[buy sell]
    create_enum :rate_type, %i[fixed relative]
    create_table :adverts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :sale_method_currency, null: false, foreign_key: { to_table: :payment_method_currencies }
      t.references :buy_method_currency, null: false, foreign_key: { to_table: :payment_method_currencies }
      t.enum :advert_type, null: false, enum_type: :advert_type
      t.decimal :min_amount, null: false
      t.decimal :max_amount, null: false
      t.enum :rate_type, null: false, enum_type: :rate_type
      t.decimal :rate_percent
      t.decimal :rate_price
      t.references :rate_source, null: false, foreign_key: true
      t.timestamp :archived_at
      t.text :details, null: false

      t.timestamps
    end

    add_check_constraint :adverts, "(rate_type = 'relative' and rate_percent is not null and rate_source_id is not null) or (rate_type='fixed' and rate_price is not null)"
  end
end

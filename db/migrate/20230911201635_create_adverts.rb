class CreateAdverts < ActiveRecord::Migration[7.0]
  def change
    create_enum :advert_type, %i[buy sell]
    create_enum :rate_type, %i[fixed fluid]
    create_table :adverts do |t|
      t.references :trader, null: false, foreign_key: { to_table: :users }
      t.references :good_method_currency, null: false, foreign_key: { to_table: :payment_method_currencies }
      t.references :payment_method_currency, null: false, foreign_key: { to_table: :payment_method_currencies }
      t.enum :advert_type, null: false, enum_type: :advert_type
      t.decimal :min_amount, null: false
      t.decimal :max_amount, null: false
      t.enum :rate_type, null: false, enum_type: :rate_type
      t.decimal :rate_percent
      t.decimal :rate_price
      t.references :rate_source, foreign_key: true
      t.timestamp :archived_at
      t.text :details, null: false

      t.timestamps
    end

    add_check_constraint :adverts, "(rate_type = 'fluid' and rate_percent is not null and rate_source_id is not null) or (rate_type='fixed' and rate_price is not null)"
  end
end

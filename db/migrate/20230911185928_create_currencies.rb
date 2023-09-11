class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_enum "currency_type", ["coin", "fiat"]
    create_table :currencies, id: :string do |t|
      t.enum :type, null: false, default: :coin, enum_type: :currency_type
      t.decimal :precision, null: false, default: 8
      t.integer :base_factor, null: false, default: 0
      t.decimal :withdraw_limit_24h, null: false, default: 0, precision: 36, scale: 18
      t.jsonb :options
      t.boolean :visible, null: false, default: true
      t.decimal :deposit_fee, null: false, default: 0, precision: 36, scale: 18
      t.string :icon_url
      t.decimal :withdraw_limit_72h, null: false, default: 0, precision: 36, scale: 18
      t.decimal :min_collection_amount, null: false, default: 0, precision: 36, scale: 18
      t.decimal :min_withdraw_amount, null: false, default: 0, precision: 36, scale: 18
      t.string :name
      t.integer :position
      t.boolean :deposit_enabled
      t.boolean :withdrawal_enabled
      t.text :description
      t.string :homepage
      t.string :price
      t.string :cc_code

      t.timestamps
    end

    change_column :currencies, :id, :string, limit: 8
    add_foreign_key :user_accounts, :currencies, on_delete: :restrict
  end
end

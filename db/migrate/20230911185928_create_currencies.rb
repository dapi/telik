class CreateCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_enum "currency_type", ["coin", "fiat"]
    create_table :currencies, id: :string do |t|
      t.enum :type, null: false, default: :coin, enum_type: :currency_type
      t.decimal :precision, null: false, default: 8
      t.integer :base_factor, null: false, default: 0

      t.timestamps
    end

    rename_column :currencies, :id, :code
    change_column :currencies, :code, :string, limit: 8
    add_foreign_key :user_accounts, :currencies, primary_key: :code, column: :currency_code, on_delete: :restrict
  end
end

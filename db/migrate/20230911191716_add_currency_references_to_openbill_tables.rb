class AddCurrencyReferencesToOpenbillTables < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :openbill_accounts, :currencies, primary_key: :code, column: :amount_currency, on_delete: :restrict
    add_foreign_key :openbill_holds, :currencies, primary_key: :code, column: :amount_currency, on_delete: :restrict
    add_foreign_key :openbill_transactions, :currencies, primary_key: :code, column: :amount_currency, on_delete: :restrict
  end
end

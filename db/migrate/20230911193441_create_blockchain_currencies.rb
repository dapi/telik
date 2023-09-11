class CreateBlockchainCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table "blockchain_currencies", force: :cascade do |t|
      t.references :blockchain, null: false
      t.references :currency, null: false, type: :string, length: 8
      t.string "contract_address"
      t.bigint "gas_limit"
      t.references :parent, table: :blockchains
      t.bigint "base_factor", null: false
      t.jsonb "options"
      t.decimal "withdraw_fee", precision: 32, scale: 18, default: "0.0", null: false
      t.decimal "min_deposit_amount", precision: 32, scale: 18, default: "0.0", null: false
      t.boolean "visible", default: true, null: false
      t.check_constraint "parent_id IS NOT NULL AND contract_address IS NOT NULL OR parent_id IS NULL AND contract_address IS NULL", name: "blockchain_currencies_contract_address"
      t.timestamps
    end
  end
end

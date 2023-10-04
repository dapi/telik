class CreateBlockchains < ActiveRecord::Migration[7.0]
  def change
    create_table "blockchains",  force: :cascade do |t|
      t.string "key", null: false
      t.string "name"
      t.bigint "height", null: false
      t.string "explorer_address"
      t.string "explorer_transaction"
      t.string "status", null: false
      t.datetime "created_at", precision: nil, null: false
      t.datetime "updated_at", precision: nil, null: false
      t.boolean "enable_invoice", default: false, null: false
      t.string "explorer_contract_address"
      t.string "client", null: false
      t.jsonb "client_options", default: {}, null: false
      t.datetime "height_updated_at", precision: nil
      t.string "client_version"
      t.string "address_type"
      t.string "gateway_klass"
      t.boolean "disable_collection", default: false, null: false
      t.boolean "allowance_enabled", default: false, null: false
      t.integer "chain_id"
    end
    add_index :blockchains, :key, unique: true
  end
end

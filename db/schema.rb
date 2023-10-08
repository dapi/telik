# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_09_14_180414) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "account_kind", ["negative", "positive", "any"]
  create_enum "advert_type", ["buy", "sell"]
  create_enum "author_type", ["taker", "maker", "arbitr"]
  create_enum "chat_type", ["trade", "taker_arbitr", "maker_arbitr"]
  create_enum "currency_type", ["coin", "fiat"]
  create_enum "rate_type", ["fixed", "fluid"]
  create_enum "trade_type", ["proposed", "wait_for_payment", "rejected_by_maker", "rejected_by_taker", "wait_for_delivery", "delivery_confirmed", "canceled"]

  create_table "adverts", force: :cascade do |t|
    t.bigint "trader_id", null: false
    t.bigint "good_method_currency_id", null: false
    t.bigint "payment_method_currency_id", null: false
    t.enum "advert_type", null: false, enum_type: "advert_type"
    t.decimal "min_amount", null: false
    t.decimal "max_amount", null: false
    t.enum "rate_type", null: false, enum_type: "rate_type"
    t.decimal "rate_percent"
    t.decimal "custom_rate_price"
    t.bigint "rate_source_id"
    t.datetime "archived_at", precision: nil
    t.text "details", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "disabled_at", precision: nil
    t.string "disable_reason"
    t.jsonb "history", default: [], null: false
    t.index ["good_method_currency_id"], name: "index_adverts_on_good_method_currency_id"
    t.index ["payment_method_currency_id"], name: "index_adverts_on_payment_method_currency_id"
    t.index ["rate_source_id"], name: "index_adverts_on_rate_source_id"
    t.index ["trader_id"], name: "index_adverts_on_trader_id"
    t.check_constraint "rate_type = 'fluid'::rate_type AND rate_percent IS NOT NULL AND rate_source_id IS NOT NULL OR rate_type = 'fixed'::rate_type AND custom_rate_price IS NOT NULL"
  end

  create_table "blockchain_currencies", force: :cascade do |t|
    t.bigint "blockchain_id", null: false
    t.string "currency_id", null: false
    t.string "contract_address"
    t.bigint "gas_limit"
    t.bigint "parent_id"
    t.bigint "base_factor", null: false
    t.jsonb "options"
    t.decimal "withdraw_fee", precision: 32, scale: 18, default: "0.0", null: false
    t.decimal "min_deposit_amount", precision: 32, scale: 18, default: "0.0", null: false
    t.boolean "visible", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blockchain_id"], name: "index_blockchain_currencies_on_blockchain_id"
    t.index ["currency_id"], name: "index_blockchain_currencies_on_currency_id"
    t.index ["parent_id"], name: "index_blockchain_currencies_on_parent_id"
    t.check_constraint "parent_id IS NOT NULL AND contract_address IS NOT NULL OR parent_id IS NULL AND contract_address IS NULL", name: "blockchain_currencies_contract_address"
  end

  create_table "blockchains", force: :cascade do |t|
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
    t.jsonb "client_options", default: {}, null: false
    t.datetime "height_updated_at", precision: nil
    t.string "client_version"
    t.string "address_type"
    t.string "gateway_klass"
    t.boolean "disable_collection", default: false, null: false
    t.boolean "allowance_enabled", default: false, null: false
    t.integer "chain_id"
    t.jsonb "explorer"
    t.index ["key"], name: "index_blockchains_on_key", unique: true
  end

  create_table "currencies", id: { type: :string, limit: 8 }, force: :cascade do |t|
    t.enum "type", default: "coin", null: false, enum_type: "currency_type"
    t.integer "precision", default: 8, null: false
    t.integer "base_factor", default: 100, null: false
    t.decimal "withdraw_limit_24h", precision: 36, scale: 18, default: "0.0", null: false
    t.jsonb "options"
    t.boolean "visible", default: true, null: false
    t.decimal "deposit_fee", precision: 36, scale: 18, default: "0.0", null: false
    t.string "icon_url"
    t.decimal "withdraw_limit_72h", precision: 36, scale: 18, default: "0.0", null: false
    t.decimal "min_collection_amount", precision: 36, scale: 18, default: "0.0", null: false
    t.decimal "min_withdraw_amount", precision: 36, scale: 18, default: "0.0", null: false
    t.string "name"
    t.integer "position"
    t.boolean "deposit_enabled"
    t.boolean "withdrawal_enabled"
    t.text "description"
    t.string "homepage"
    t.string "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "openbill_accounts", id: { comment: "Account unique id" }, comment: "Account. Has a unique bigint identifier. Has information about the state of the account (balance), currency", force: :cascade do |t|
    t.bigint "category_id", null: false, comment: "Account category id, referenes on table OPENBILL_CATEGORIES. Use for grouping accounts"
    t.decimal "amount_value", precision: 36, scale: 18, default: "0.0", null: false, comment: "Account balance"
    t.string "amount_currency", limit: 8, default: "USD", null: false, comment: "Account currency"
    t.text "details", comment: "Account description"
    t.integer "transactions_count", default: 0, null: false, comment: "Number of transactions per account"
    t.jsonb "meta", default: {}, null: false, comment: "Account description in json format"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, comment: "Date time of account creation"
    t.datetime "updated_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, comment: "Date time of account modificaton"
    t.decimal "hold_value", precision: 36, scale: 18, default: "0.0", null: false, comment: "Hold amount"
    t.datetime "locked_at", precision: nil, comment: "The date the funds were holded. If the value is NULL there is no blocking"
    t.enum "kind", default: "any", null: false, comment: "Account type", enum_type: "account_kind"
    t.string "reference_type"
    t.bigint "reference_id"
    t.index ["created_at"], name: "index_accounts_on_created_at"
    t.index ["id"], name: "index_accounts_on_id", unique: true
    t.index ["meta"], name: "index_accounts_on_meta", using: :gin
    t.check_constraint "kind = 'positive'::account_kind AND amount_value >= 0::numeric OR kind = 'negative'::account_kind AND amount_value <= 0::numeric OR kind = 'any'::account_kind", name: "openbill_accounts_kind"
  end

  create_table "openbill_categories", id: { comment: "Account category id" }, comment: "Account category. A convenient way to group accounts, for example: user accounts and system accounts, and also restrict transactions.", force: :cascade do |t|
    t.string "name", limit: 256, null: false, comment: "Account category name"
    t.index ["name"], name: "index_openbill_categories_name", unique: true
  end

  create_table "openbill_holds", id: { comment: "Hold unique id" }, comment: "Оperation of blocking funds on the account. Has a unique identifier, account identifier, blocking amount, description.", force: :cascade do |t|
    t.date "date", default: -> { "CURRENT_DATE" }, null: false, comment: "Foreign date time of hold creation"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, comment: "Date time of hold creation"
    t.bigint "account_id", null: false, comment: "Account which the funds are holded"
    t.decimal "amount_value", precision: 36, scale: 18, null: false, comment: "Hold amount"
    t.string "amount_currency", limit: 8, default: "USD", null: false, comment: "Hold currency"
    t.string "remote_idempotency_key", limit: 256, null: false, comment: "Human readable unique hold key"
    t.text "details", null: false, comment: "Hold description"
    t.jsonb "meta", default: {}, null: false, comment: "Hold description in json format"
    t.string "hold_key", limit: 256
    t.index ["meta"], name: "index_holds_on_meta", using: :gin
    t.index ["remote_idempotency_key"], name: "index_holds_on_key", unique: true
    t.index ["remote_idempotency_key"], name: "openbill_holds_remote_idempotency_key_key", unique: true
    t.check_constraint "amount_value < 0::numeric AND hold_key IS NOT NULL OR amount_value > 0::numeric AND hold_key IS NULL", name: "openbill_holds_check"
  end

  create_table "openbill_policies", id: { comment: "Policy unique id" }, comment: "Funds transfer policies. Using this table, you can restrict the movement of funds between accounts. For example, allow write-offs from user accounts only to system ones.", force: :cascade do |t|
    t.string "name", limit: 256, null: false, comment: "Policy name"
    t.bigint "from_category_id", comment: "Category of accounts from which transfers are possible (NULL for all)"
    t.bigint "to_category_id", comment: "Category of accounts to which transfers are possible (NULL for all)"
    t.bigint "from_account_id", comment: "Accounts from which transfers are possible (NULL for all)"
    t.bigint "to_account_id", comment: "Fccounts to which transfers are possible (NULL for all)"
    t.boolean "allow_reverse", default: true, null: false
    t.index ["name"], name: "index_openbill_policies_name", unique: true
  end

  create_table "openbill_transactions", id: { comment: "Transaction unique id" }, comment: "The operation of transferring funds between accounts. Has a unique identifier, identifiers of incoming and outgoing accounts, transaction amount, description.", force: :cascade do |t|
    t.date "billing_date", default: -> { "CURRENT_DATE" }, null: false, comment: "Foreign date time of transaction creation"
    t.datetime "created_at", precision: nil, default: -> { "CURRENT_TIMESTAMP" }, comment: "Date time of transaction creation"
    t.bigint "from_account_id", null: false, comment: "Account from which the funds are transferred"
    t.bigint "to_account_id", null: false, comment: "Account to which funds are transferred"
    t.decimal "amount_value", precision: 36, scale: 18, null: false, comment: "Transfer amount"
    t.string "amount_currency", limit: 8, default: "USD", null: false, comment: "Transfer currency"
    t.string "remote_idempotency_key", limit: 256, null: false, comment: "Human readable unique transaction key"
    t.text "details", null: false, comment: "Transaction description"
    t.jsonb "meta", default: {}, null: false, comment: "Transaction description in json format"
    t.bigint "reverse_transaction_id"
    t.index ["created_at"], name: "index_transactions_on_created_at"
    t.index ["meta"], name: "index_transactions_on_meta", using: :gin
    t.index ["remote_idempotency_key"], name: "index_transactions_on_key", unique: true
    t.check_constraint "amount_value > 0::numeric", name: "positive"
    t.check_constraint "to_account_id <> from_account_id", name: "different_accounts"
  end

  create_table "payment_method_currencies", force: :cascade do |t|
    t.bigint "payment_method_id", null: false
    t.string "currency_id", limit: 8, null: false
    t.boolean "available_in", default: false, null: false
    t.boolean "available_out", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_payment_method_currencies_on_currency_id"
    t.index ["payment_method_id"], name: "index_payment_method_currencies_on_payment_method_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "available_in", default: false, null: false
    t.boolean "available_out", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_payment_methods_on_name", unique: true
  end

  create_table "rate_sources", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_rate_sources_on_name", unique: true
  end

  create_table "telegram_users", force: :cascade do |t|
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.jsonb "dump"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trade_messages", force: :cascade do |t|
    t.bigint "trade_id", null: false
    t.bigint "user_id", null: false
    t.text "content", null: false
    t.enum "chat_type", null: false, enum_type: "chat_type"
    t.enum "author_type", null: false, enum_type: "author_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trade_id"], name: "index_trade_messages_on_trade_id"
    t.index ["user_id"], name: "index_trade_messages_on_user_id"
  end

  create_table "trades", force: :cascade do |t|
    t.bigint "advert_id", null: false
    t.bigint "taker_id", null: false
    t.enum "state", null: false, enum_type: "trade_type"
    t.decimal "comission_percent", null: false
    t.decimal "good_amount", null: false, comment: "Сколько товара покупает/продает клиент (taker)"
    t.string "good_currency_id", limit: 8, null: false
    t.decimal "comission_amount", null: false
    t.decimal "total_transfer_amount", null: false
    t.decimal "client_transfer_amount", null: false, comment: "Сколько клиент платит/получает за купленный/проданный товар"
    t.string "transfer_currency_id", limit: 8, null: false
    t.enum "rate_type", null: false, enum_type: "rate_type"
    t.decimal "rate_percent"
    t.decimal "rate_price", null: false
    t.bigint "rate_source_id"
    t.text "advert_details", null: false
    t.jsonb "history", default: [], null: false
    t.datetime "accepted_at", precision: nil
    t.jsonb "advert_dump", default: {}, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["advert_id"], name: "index_trades_on_advert_id"
    t.index ["good_currency_id"], name: "index_trades_on_good_currency_id"
    t.index ["rate_source_id"], name: "index_trades_on_rate_source_id"
    t.index ["taker_id"], name: "index_trades_on_taker_id"
    t.index ["transfer_currency_id"], name: "index_trades_on_transfer_currency_id"
    t.check_constraint "total_transfer_amount = (client_transfer_amount + comission_amount)"
  end

  create_table "user_accounts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "currency_id", limit: 8, null: false
    t.bigint "openbill_account_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_user_accounts_on_currency_id"
    t.index ["openbill_account_id"], name: "index_user_accounts_on_openbill_account_id_uniq", unique: true
    t.index ["user_id", "currency_id"], name: "index_user_accounts_on_user_id_and_currency_id", unique: true
    t.index ["user_id"], name: "index_user_accounts_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "crypted_password"
    t.string "salt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "remember_me_token"
    t.datetime "remember_me_token_expires_at"
    t.datetime "last_login_at"
    t.datetime "last_logout_at"
    t.datetime "last_activity_at"
    t.string "last_login_from_ip_address"
    t.bigint "telegram_user_id", null: false
    t.jsonb "telegram_data", default: {}, null: false
    t.boolean "super_admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["telegram_user_id"], name: "index_users_on_telegram_user_id"
  end

  add_foreign_key "adverts", "payment_method_currencies"
  add_foreign_key "adverts", "payment_method_currencies", column: "good_method_currency_id"
  add_foreign_key "adverts", "rate_sources"
  add_foreign_key "adverts", "users", column: "trader_id"
  add_foreign_key "openbill_accounts", "currencies", column: "amount_currency", on_delete: :restrict
  add_foreign_key "openbill_accounts", "openbill_categories", column: "category_id", name: "openbill_accounts_category_id_fkey", on_delete: :restrict
  add_foreign_key "openbill_holds", "currencies", column: "amount_currency", on_delete: :restrict
  add_foreign_key "openbill_holds", "openbill_accounts", column: "account_id", name: "openbill_holds_account_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "openbill_holds", "openbill_holds", column: "hold_key", primary_key: "remote_idempotency_key", name: "openbill_holds_hold_key_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "openbill_policies", "openbill_accounts", column: "from_account_id", name: "openbill_policies_from_account_id_fkey"
  add_foreign_key "openbill_policies", "openbill_accounts", column: "to_account_id", name: "openbill_policies_to_account_id_fkey"
  add_foreign_key "openbill_policies", "openbill_categories", column: "from_category_id", name: "openbill_policies_from_category_id_fkey"
  add_foreign_key "openbill_policies", "openbill_categories", column: "to_category_id", name: "openbill_policies_to_category_id_fkey"
  add_foreign_key "openbill_transactions", "currencies", column: "amount_currency", on_delete: :restrict
  add_foreign_key "openbill_transactions", "openbill_accounts", column: "from_account_id", name: "openbill_transactions_from_account_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "openbill_transactions", "openbill_accounts", column: "to_account_id", name: "openbill_transactions_to_account_id_fkey"
  add_foreign_key "openbill_transactions", "openbill_transactions", column: "reverse_transaction_id", name: "reverse_transaction_foreign_key"
  add_foreign_key "payment_method_currencies", "currencies"
  add_foreign_key "payment_method_currencies", "payment_methods"
  add_foreign_key "trade_messages", "trades"
  add_foreign_key "trade_messages", "users"
  add_foreign_key "trades", "adverts"
  add_foreign_key "trades", "currencies", column: "good_currency_id"
  add_foreign_key "trades", "currencies", column: "transfer_currency_id"
  add_foreign_key "trades", "rate_sources"
  add_foreign_key "trades", "users", column: "taker_id"
  add_foreign_key "user_accounts", "currencies", on_delete: :restrict
  add_foreign_key "user_accounts", "users"
end

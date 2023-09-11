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

ActiveRecord::Schema[7.0].define(version: 2023_09_11_180816) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "account_kind", ["negative", "positive", "any"]

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

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
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
    t.index ["telegram_user_id"], name: "index_users_on_telegram_user_id", unique: true
  end

  add_foreign_key "openbill_accounts", "openbill_categories", column: "category_id", name: "openbill_accounts_category_id_fkey", on_delete: :restrict
  add_foreign_key "openbill_holds", "openbill_accounts", column: "account_id", name: "openbill_holds_account_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "openbill_holds", "openbill_holds", column: "hold_key", primary_key: "remote_idempotency_key", name: "openbill_holds_hold_key_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "openbill_policies", "openbill_accounts", column: "from_account_id", name: "openbill_policies_from_account_id_fkey"
  add_foreign_key "openbill_policies", "openbill_accounts", column: "to_account_id", name: "openbill_policies_to_account_id_fkey"
  add_foreign_key "openbill_policies", "openbill_categories", column: "from_category_id", name: "openbill_policies_from_category_id_fkey"
  add_foreign_key "openbill_policies", "openbill_categories", column: "to_category_id", name: "openbill_policies_to_category_id_fkey"
  add_foreign_key "openbill_transactions", "openbill_accounts", column: "from_account_id", name: "openbill_transactions_from_account_id_fkey", on_update: :restrict, on_delete: :restrict
  add_foreign_key "openbill_transactions", "openbill_accounts", column: "to_account_id", name: "openbill_transactions_to_account_id_fkey"
  add_foreign_key "openbill_transactions", "openbill_transactions", column: "reverse_transaction_id", name: "reverse_transaction_foreign_key"
end

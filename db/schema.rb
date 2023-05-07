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

ActiveRecord::Schema[7.0].define(version: 2023_05_07_171021) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "projects", force: :cascade do |t|
    t.string "domain", null: false
    t.string "key", null: false
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_projects_on_key", unique: true
    t.index ["owner_id"], name: "index_projects_on_owner_id"
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
    t.bigint "telegram_id", null: false
    t.jsonb "telegram_data", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["telegram_id"], name: "index_users_on_telegram_id", unique: true
  end

  create_table "visitors", force: :cascade do |t|
    t.string "cookie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cookie_id"], name: "index_visitors_on_cookie_id", unique: true
  end

  create_table "visits", force: :cascade do |t|
    t.string "key", null: false
    t.bigint "visitor_id", null: false
    t.inet "remote_ip", null: false
    t.jsonb "data", default: {}, null: false
    t.string "url", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_visits_on_key", unique: true
    t.index ["visitor_id"], name: "index_visits_on_visitor_id"
  end

  add_foreign_key "projects", "users", column: "owner_id"
  add_foreign_key "visits", "visitors"
end

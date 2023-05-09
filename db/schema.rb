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

ActiveRecord::Schema[7.0].define(version: 2023_05_09_065033) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id", "user_id"], name: "index_memberships_on_project_id_and_user_id", unique: true
    t.index ["project_id"], name: "index_memberships_on_project_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "projects", force: :cascade do |t|
    t.string "url", null: false
    t.string "host", null: false
    t.string "key", null: false
    t.datetime "host_confirmed_at", precision: nil
    t.bigint "owner_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "telegram_group_id"
    t.index ["key"], name: "index_projects_on_key", unique: true
    t.index ["owner_id", "host"], name: "index_projects_on_owner_id_and_host", unique: true
    t.index ["owner_id"], name: "index_projects_on_owner_id"
    t.index ["url", "owner_id"], name: "index_projects_on_url_and_owner_id", unique: true
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
    t.jsonb "telegram_data", default: {}, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
    t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    t.index ["telegram_id"], name: "index_users_on_telegram_id", unique: true
  end

  create_table "visitors", force: :cascade do |t|
    t.string "cookie_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "project_id", null: false
    t.bigint "telegram_message_thread_id"
    t.string "cached_telegram_topic_name"
    t.bigint "cached_telegram_topic_icon_color"
    t.datetime "telegram_cached_at", precision: nil
    t.string "first_name"
    t.string "last_name"
    t.string "username"
    t.bigint "telegram_id"
    t.bigint "first_visit_id"
    t.bigint "last_visit_id"
    t.index ["first_visit_id"], name: "index_visitors_on_first_visit_id"
    t.index ["last_visit_id"], name: "index_visitors_on_last_visit_id"
    t.index ["project_id", "cookie_id"], name: "index_visitors_on_project_id_and_cookie_id", unique: true
    t.index ["project_id"], name: "index_visitors_on_project_id"
  end

  create_table "visits", force: :cascade do |t|
    t.string "key", null: false
    t.bigint "visitor_id", null: false
    t.inet "remote_ip", null: false
    t.jsonb "location", null: false
    t.jsonb "data", default: {}, null: false
    t.jsonb "chat"
    t.string "referrer"
    t.datetime "registered_at", precision: nil
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key"], name: "index_visits_on_key", unique: true
    t.index ["visitor_id"], name: "index_visits_on_visitor_id"
  end

  add_foreign_key "memberships", "projects"
  add_foreign_key "memberships", "users"
  add_foreign_key "projects", "users", column: "owner_id"
  add_foreign_key "visits", "visitors"
end

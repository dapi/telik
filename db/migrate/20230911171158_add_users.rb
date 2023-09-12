class AddUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :telegram_users do |t|
      t.string "first_name"
      t.string "last_name"
      t.string "username"
      t.jsonb :dump
      t.timestamps
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
      t.references :telegram_user, null: false
      t.jsonb "telegram_data", default: {}, null: false
      t.boolean "super_admin", default: false, null: false
      t.index ["email"], name: "index_users_on_email", unique: true
      t.index ["last_logout_at", "last_activity_at"], name: "index_users_on_last_logout_at_and_last_activity_at"
      t.index ["remember_me_token"], name: "index_users_on_remember_me_token"
    end
  end
end

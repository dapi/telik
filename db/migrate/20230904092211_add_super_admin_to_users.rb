class AddSuperAdminToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :super_admin, :boolean, null: false, default: false
    User.where(telegram_user_id: 943084337).update_all super_admin: true
  end
end

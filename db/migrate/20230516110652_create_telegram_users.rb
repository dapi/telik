class CreateTelegramUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :telegram_users, id: false do |t|
      t.bigint :id, options: 'PRIMARY KEY'
      t.string "first_name"
      t.string "last_name"
      t.string "username"
      t.timestamps
    end

    remove_column :visitors, :first_name
    remove_column :visitors, :last_name
    remove_column :visitors, :username

    remove_column :visitors, :telegram_id
    add_reference :visitors, :telegram_user

    add_index :visitors, %i[project_id telegram_user_id], unique: true, where: 'telegram_user_id is not null'
  end
end

class CreateUserAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :user_accounts do |t|
      t.references :user, null: false, foreign_key: true
      t.string :currency_code, null: false, limit: 8
      t.references :openbill_account, null: false

      t.timestamps
    end

    add_index :user_accounts, %i[user_id currency_code], unique: true
    add_index :user_accounts, :currency_code
    add_index :user_accounts, :openbill_account_id, unique: true, name: :index_user_accounts_on_openbill_account_id_uniq
    remove_index :user_accounts, name: :index_user_accounts_on_openbill_account_id

  end
end

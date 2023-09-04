class CreateTariffs < ActiveRecord::Migration[7.0]
  def change
    create_table :tariffs do |t|
      t.decimal :price, null: false
      t.string :title, null: false
      t.text :details, null: false
      t.integer :max_visitors_count, null: false
      t.integer :max_operators_count, null: false
      t.boolean :custom_bot_allowed, null: false
      t.boolean :transaction_mails_allowed, null: false
      t.boolean :marketing_mails_allowed, null: false
      t.integer :position, null: false
      t.timestamp :archived_at

      t.timestamps
    end

    add_index :tariffs, :position, unique: true
  end
end

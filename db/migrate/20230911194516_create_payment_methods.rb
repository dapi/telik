class CreatePaymentMethods < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_methods do |t|
      t.string :name, null: false
      t.boolean :available_in, null: false, default: false
      t.boolean :available_out, null: false, default: false

      t.timestamps
    end

    add_index :payment_methods, :name, unique: true
  end
end

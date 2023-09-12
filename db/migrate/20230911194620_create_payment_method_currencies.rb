class CreatePaymentMethodCurrencies < ActiveRecord::Migration[7.0]
  def change
    create_table :payment_method_currencies do |t|
      t.references :payment_method, null: false, foreign_key: true
      t.references :currency, null: false, foreign_key: true, type: :string, limit: 8
      t.boolean :available_in, null: false, default: false
      t.boolean :available_out, null: false, default: false

      t.timestamps
    end
  end
end

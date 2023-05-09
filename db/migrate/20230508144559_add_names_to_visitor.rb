class AddNamesToVisitor < ActiveRecord::Migration[7.0]
  def change
    add_column :visitors, :first_name, :string
    add_column :visitors, :last_name, :string
    add_column :visitors, :username, :string
    add_column :visitors, :telegram_id, :bigint
    add_reference :visitors, :first_visit, to_table: :visits
    add_reference :visitors, :last_visit, to_table: :visits
  end
end

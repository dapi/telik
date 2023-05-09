class AddNamesToVisitor < ActiveRecord::Migration[7.0]
  def change
    add_column :visitors, :name, :string
    add_column :visitors, :surname, :string
    add_reference :visitors, :first_visit, to_table: :visits
    add_reference :visitors, :last_visit, to_table: :visits
  end
end

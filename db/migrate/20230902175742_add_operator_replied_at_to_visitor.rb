class AddOperatorRepliedAtToVisitor < ActiveRecord::Migration[7.0]
  def change
    add_column :visitors, :operator_replied_at, :timestamp
  end
end

class AddUserDataToVisitors < ActiveRecord::Migration[7.0]
  def change
    add_column :visitors, :user_data, :jsonb, null: false, default: true
  end
end

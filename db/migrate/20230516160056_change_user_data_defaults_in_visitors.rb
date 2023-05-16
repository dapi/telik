class ChangeUserDataDefaultsInVisitors < ActiveRecord::Migration[7.0]
  def change
    change_column_default :visitors, :user_data, {}
    Visitor.update_all user_data: {}
  end
end

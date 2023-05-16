class AddUniqueTelegramIndexToVisitors < ActiveRecord::Migration[7.0]
  def change
    Visit.delete_all
    Visitor.delete_all
    add_index :visitors, %i[project_id telegram_id], unique: true
  end
end

class AddUniqueTelegramIndexToVisitors < ActiveRecord::Migration[7.0]
  def change
    Visitor.destroy_all
    add_index :visitors, %i[project_id telegram_id], unique: true
  end
end

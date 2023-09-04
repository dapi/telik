class AddTitleUniquenessToTariffs < ActiveRecord::Migration[7.0]
  def change
    add_index :tariffs, :title, unique: true
  end
end

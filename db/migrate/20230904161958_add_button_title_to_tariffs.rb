class AddButtonTitleToTariffs < ActiveRecord::Migration[7.0]
  def change
    add_column :tariffs, :button_title, :string
    require './db/seeds/tariffs.rb'
    change_column_null :tariffs, :button_title, false
  end
end

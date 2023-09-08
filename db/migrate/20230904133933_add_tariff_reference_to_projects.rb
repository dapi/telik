class AddTariffReferenceToProjects < ActiveRecord::Migration[7.0]
  def up
    add_column :tariffs, :button_title, :string
    require './db/seeds/tariffs.rb'
    change_column_null :tariffs, :button_title, false
    add_reference :projects, :tariff, foreign_key: true
    Project.update_all tariff_id: Tariff.ordered.first.id
    change_column_null :projects, :tariff_id, false
  end

  def down
    remove_reference :projects, :tariff
  end
end

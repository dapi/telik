require './db/seeds/tariffs.rb'
class AddTariffReferenceToProjects < ActiveRecord::Migration[7.0]
  def up
    add_reference :projects, :tariff, foreign_key: true
    Project.update_all tariff_id: Tariff.ordered.first.id
    change_column_null :projects, :tariff_id, false
  end

  def down
    remove_reference :projects, :tariff
  end
end

class AddDefaultToTariffs < ActiveRecord::Migration[7.0]
  def change
    add_column :tariffs, :is_default, :boolean, null: false, default: false
    Tariff.find_by(position: 1).update is_default: true
  end
end

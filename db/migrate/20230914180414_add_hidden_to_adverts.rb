class AddHiddenToAdverts < ActiveRecord::Migration[7.0]
  def change
    add_column :adverts, :disabled_at, :timestamp
    add_column :adverts, :disable_reason, :string
    add_column :adverts, :history, :jsonb, null: false, default: []
  end
end

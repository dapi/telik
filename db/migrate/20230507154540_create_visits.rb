class CreateVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :visits do |t|
      t.references :visitor, null: false, foreign_key: true
      t.inet :remote_ip, null: false
      t.jsonb :data, null: false, default: {}
      t.string :url, null: false

      t.timestamps
    end
  end
end

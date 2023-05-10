class CreateVisits < ActiveRecord::Migration[7.0]
  def change
    create_table :visits do |t|
      t.string :key, null: false
      t.references :visitor, null: false, foreign_key: true
      t.inet :remote_ip, null: false
      t.jsonb :location, null: false
      t.jsonb :data, null: false, default: {}
      t.jsonb :chat
      t.string :referrer
      t.timestamp :registered_at

      t.timestamps
    end

    add_index :visits, :key, unique: true
  end
end

class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :url, null: false
      t.string :host, null: false
      t.string :key, null: false
      t.timestamp :host_confirmed_at
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :projects, :key, unique: true
    add_index :projects, %i[owner_id host], unique: true
    add_index :projects, %i[url owner_id], unique: true

    add_reference :visitors, :project, null: false
    remove_index :visitors, :cookie_id, unique: true
    add_index :visitors, %i[project_id cookie_id], unique: true
  end
end

class CreateProjects < ActiveRecord::Migration[7.0]
  def change
    create_table :projects do |t|
      t.string :domain, null: false
      t.string :key, null: false
      t.references :owner, null: false, foreign_key: { to_table: :users }

      t.timestamps
    end
    add_index :projects, :key, unique: true
  end
end

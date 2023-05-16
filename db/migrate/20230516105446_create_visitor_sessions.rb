class CreateVisitorSessions < ActiveRecord::Migration[7.0]
  def change
    create_table :visitor_sessions do |t|
      t.string :cookie_id, null: false
      t.references :project, null: false, foreign_key: true
      t.references :visitor, null: true, foreign_key: true

      t.timestamps
    end

    add_index :visitor_sessions, %i[cookie_id project_id], unique: true

    remove_column :visitors, :cookie_id
  end
end

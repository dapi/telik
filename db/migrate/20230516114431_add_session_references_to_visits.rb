class AddSessionReferencesToVisits < ActiveRecord::Migration[7.0]
  def change
    remove_column :visits, :visitor_id
    add_reference :visits, :visitor_session, null: false
  end
end

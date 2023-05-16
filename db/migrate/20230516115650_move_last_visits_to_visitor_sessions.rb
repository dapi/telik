class MoveLastVisitsToVisitorSessions < ActiveRecord::Migration[7.0]
  def change
    remove_column :visitors, :last_visit_id
    remove_column :visitors, :first_visit_id

    add_reference :visitor_sessions, :last_visit, to_table: :visits
    add_reference :visitor_sessions, :first_visit, to_table: :visits
  end
end

class AddLastVisitAtToVisits < ActiveRecord::Migration[7.0]
  def change
    add_column :visitors, :last_visit_at, :timestamp

    Visitor.find_each do |v|
      v.update! last_visit_at: v.last_visit.try(:created_at)
    end
  end
end

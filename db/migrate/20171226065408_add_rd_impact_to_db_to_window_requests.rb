class AddRdImpactToDbToWindowRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :window_requests, :rd_impact_to_db, :text
  end
end

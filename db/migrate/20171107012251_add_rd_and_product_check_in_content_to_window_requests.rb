class AddRdAndProductCheckInContentToWindowRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :window_requests, :bugid, :string, default: 'NULL'
    add_column :window_requests, :filetext, :text, default: 'NULL'
    add_column :window_requests, :textdone, :string, default: 'NULL'
    add_column :window_requests, :Group_qa_coverage, :string, default: 'NULL'
    add_column :window_requests, :justification_back_porting, :text, default: 'NULL'
    add_column :window_requests, :change_summary, :text, default: 'NULL'
    add_column :window_requests, :impact_to_db, :text, default: 'NULL'
    add_column :window_requests, :history, :text, default: 'NULL'
    add_column :window_requests, :ae_contact, :string, default: 'NULL'
    add_column :window_requests, :product_category, :string, default: 'NULL'
  end
end

class AddReasonNotRdToWindowRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :window_requests, :reason_not_rd, :text
  end
end

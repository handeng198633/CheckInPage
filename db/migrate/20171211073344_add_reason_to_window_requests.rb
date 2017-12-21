class AddReasonToWindowRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :window_requests, :reason, :string,  default: 'NULL'
  end
end

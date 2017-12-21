class AddSendMailToWindowRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :window_requests, :mail_cc_list, :string
    add_column :window_requests, :send_copy_ornot, :string, default: 'no'
  end
end

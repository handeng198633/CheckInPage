class AddTimeRangeToWindowRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :window_requests, :time_range, :string
  end
end

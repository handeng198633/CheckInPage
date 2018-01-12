class AddProductLineToWindowRequests < ActiveRecord::Migration[5.1]
  def change
    add_column :window_requests, :product_line, :string
  end
end

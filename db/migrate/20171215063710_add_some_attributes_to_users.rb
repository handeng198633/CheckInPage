class AddSomeAttributesToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :login_id, :string
    add_column :users, :realname, :string
    add_column :users, :product_line, :string, default: 'RH'
  end
end

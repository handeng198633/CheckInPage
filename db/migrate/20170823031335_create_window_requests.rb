class CreateWindowRequests < ActiveRecord::Migration[5.1]
  def change
    create_table :window_requests do |t|
      t.string :email
      t.string :username
      t.string :version
      t.text :comment
      t.string :status
      t.datetime :window_start
      t.datetime :window_end
      t.integer :lasting_hour
      t.integer :user_id

      t.timestamps
    end
  end
end

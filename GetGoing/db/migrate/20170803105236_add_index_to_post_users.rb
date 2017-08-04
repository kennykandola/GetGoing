class AddIndexToPostUsers < ActiveRecord::Migration[5.1]
  def change
    add_index :post_users, [:post_id, :user_id], unique: true, name: 'post_user_index'
  end
end

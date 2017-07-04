class AddExpiredAtAndOpenToPosts < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :expired_at, :date
    remove_column :posts, :status
    add_column :posts, :status, :boolean, default: true, null: false
  end
end

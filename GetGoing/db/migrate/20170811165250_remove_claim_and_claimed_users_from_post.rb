class RemoveClaimAndClaimedUsersFromPost < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :claim, :integer
    remove_column :posts, :claimed_users, :string
  end
end

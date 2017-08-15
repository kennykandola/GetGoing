class AddInvitationTokenToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :invitation_token, :string
    add_index :posts, :invitation_token, unique: true
  end
end

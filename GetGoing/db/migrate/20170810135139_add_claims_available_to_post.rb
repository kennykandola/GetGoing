class AddClaimsAvailableToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :claims_available, :boolean, default: true
  end
end

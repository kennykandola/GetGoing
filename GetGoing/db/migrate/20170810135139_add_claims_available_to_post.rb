class AddClaimsAvailableToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :claims_available, :boolean
  end
end

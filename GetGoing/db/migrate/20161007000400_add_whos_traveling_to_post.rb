class AddWhosTravelingToPost < ActiveRecord::Migration
  def change
    add_column :posts, :whos_traveling, :string
  end
end

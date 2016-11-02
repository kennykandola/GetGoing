class AddDestinationToPost < ActiveRecord::Migration
  def change
    add_column :posts, :destination, :string
  end
end

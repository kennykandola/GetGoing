class RemoveObsoleteFieldsFromPost < ActiveRecord::Migration[5.1]
  def change
    remove_column :posts, :whos_traveling, :string
    remove_column :posts, :travel_dates, :string
  end
end

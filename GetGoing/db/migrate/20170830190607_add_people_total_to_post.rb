class AddPeopleTotalToPost < ActiveRecord::Migration[5.1]
  def change
    add_column :posts, :people_total, :integer, default: 1
  end
end

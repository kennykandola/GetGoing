class AddBudgetToPost < ActiveRecord::Migration
  def change
    add_column :posts, :budget, :string
  end
end

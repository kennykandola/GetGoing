class CreateClaims < ActiveRecord::Migration[5.1]
  def change
    create_table :claims do |t|
      t.belongs_to :user, foreign_key: true, index: true
      t.belongs_to :post, foreign_key: true, index: true
      t.integer :status

      t.timestamps
    end

    add_index :claims, [:user_id, :post_id], unique: true
  end
end

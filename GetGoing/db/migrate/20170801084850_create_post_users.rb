class CreatePostUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :post_users do |t|
      t.belongs_to :post, foreign_key: true, index: true
      t.belongs_to :user, foreign_key: true, index: true
      t.integer :role, index: true

      t.timestamps
    end
  end
end

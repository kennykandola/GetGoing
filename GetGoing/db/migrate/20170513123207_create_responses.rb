class CreateResponses < ActiveRecord::Migration[5.1]
  def change
    create_table :responses do |t|
      t.references :post, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.text       :body
      t.boolean    :top, default: false

      t.timestamps null: false
    end
  end
end

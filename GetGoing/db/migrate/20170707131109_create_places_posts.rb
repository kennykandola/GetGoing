class CreatePlacesPosts < ActiveRecord::Migration[5.1]
  def change
    create_table :place_post_relations do |t|
      t.belongs_to :place, foreign_key: true, index: true
      t.belongs_to :post, foreign_key: true, index: true
    end

    add_index :place_post_relations, [:place_id, :post_id], unique: true
  end
end

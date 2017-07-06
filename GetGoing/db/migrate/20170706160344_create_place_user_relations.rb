class CreatePlaceUserRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :place_user_relations do |t|
      t.belongs_to :user,     index: true
      t.belongs_to :place,    index: true
      t.integer    :relation, index: true, default: 0, null: false

      t.timestamps
    end

    add_index :place_user_relations, [:user_id, :place_id], unique: true

  end
end

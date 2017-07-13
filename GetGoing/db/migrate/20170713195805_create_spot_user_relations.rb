class CreateSpotUserRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :spot_user_relations do |t|
      t.belongs_to :spot, foreign_key: true, index: true
      t.belongs_to :user, foreign_key: true, index: true
    end

    add_index :spot_user_relations, [:spot_id, :user_id], unique: true
  end
end

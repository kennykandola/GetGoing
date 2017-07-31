class CreateSpots < ActiveRecord::Migration[5.1]
  def change
    create_table :spots do |t|
      t.string :name
      t.string :fb_id
      t.belongs_to :place, foreign_key: true, index: true

      t.timestamps
    end

    add_index :spots, :fb_id, unique: true
  end
end

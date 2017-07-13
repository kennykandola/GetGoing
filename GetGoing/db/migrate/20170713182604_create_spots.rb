class CreateSpots < ActiveRecord::Migration[5.1]
  def change
    create_table :spots do |t|
      t.string :name
      t.integer :fb_id, index: true
      t.belongs_to :place, foreign_key: true

      t.timestamps
    end
  end
end

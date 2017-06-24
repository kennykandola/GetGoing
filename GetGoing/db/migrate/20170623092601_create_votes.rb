class CreateVotes < ActiveRecord::Migration[5.1]
  def change
    create_table :votes do |t|
      t.belongs_to :user, foreign_key: true
      t.belongs_to :booking_link, foreign_key: true
      t.integer :value

      t.timestamps
    end
  end
end

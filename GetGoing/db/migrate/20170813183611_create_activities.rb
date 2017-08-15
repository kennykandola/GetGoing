class CreateActivities < ActiveRecord::Migration[5.1]
  def change
    create_table :activities do |t|
      t.integer :actor_id, index: true
      t.integer :acted_id
      t.integer :action
      t.integer :actionable_id
      t.string :actionable_type

      t.timestamps
    end

    add_index :activities, [:actionable_type, :actionable_id]
  end
end

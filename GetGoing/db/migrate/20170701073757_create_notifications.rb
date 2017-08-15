class CreateNotifications < ActiveRecord::Migration[5.1]
  def change
    create_table :notifications do |t|
      t.integer  :recipient_id, index: true
      t.integer  :actor_id, index: true
      t.integer  :notifiable_id
      t.string   :notifiable_type
      t.datetime :read_at
      t.integer  :action, default: 0, null: false

      t.timestamps
    end

    add_index :notifications, [:notifiable_type, :notifiable_id]
  end
end

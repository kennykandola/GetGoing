class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string     :title
      t.string     :offering
      t.string     :who_is_traveling
      t.text       :body
      t.string     :whos_traveling
      t.string     :budget
      t.string     :travel_dates
      t.string     :destination
      t.references :user, index: true, foreign_key: true
      t.integer    :top_responses_count
      t.integer    :claim, default: 0
      t.string     :claimed_users, default: "--- []\n"
      t.string     :structured
      t.string     :already_booked

      t.timestamps null: false
    end
  end
end

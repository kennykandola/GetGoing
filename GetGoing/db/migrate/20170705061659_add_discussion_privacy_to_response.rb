class AddDiscussionPrivacyToResponse < ActiveRecord::Migration[5.1]
  def change
    add_column :responses, :discussion_privacy, :integer, default: 0, null: false
  end
end

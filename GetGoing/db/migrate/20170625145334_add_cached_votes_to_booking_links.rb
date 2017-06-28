class AddCachedVotesToBookingLinks < ActiveRecord::Migration[5.1]
  def change
    add_column :booking_links, :cached_votes_up, :integer, default: 0
    add_column :booking_links, :cached_votes_down, :integer, default: 0
  end
end

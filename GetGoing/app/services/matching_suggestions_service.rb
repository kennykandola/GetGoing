# frozen_string_literal: true
# This class handles finding users for suggesting new posts in places they have visited/lived or near places they have visited/lived
class MatchingSuggestionsService
  attr_reader :direct_users, :nearby_users

  def initialize(params)
    @post = Post.find(params[:post_id])
    @direct_places = @post.places
    @nearby_places = find_nearby_places
    @author_id = @post.owner.id
    @direct_users = []
    @nearby_users = []
  end

  def find_nearby_places
    nearby_places = []
    direct_places_ids = @direct_places.pluck(:id)
    @direct_places.each do |place|
      places = Place.near([place.latitude, place.longitude], 20)
                    .where(country: place.country)
                    .where.not(id: direct_places_ids)
                    .to_a
      nearby_places.push(*places)
    end
    nearby_places
  end

  def find_users
    find_direct_users
    find_nearby_users
    @direct_users.uniq!(&:id)
    @nearby_users.uniq!(&:id)
  end

  def find_direct_users
    @direct_places.each do |place|
      users = place.users.where.not(id: @author_id).to_a
      @direct_users.push(*users)
    end
  end

  def find_nearby_users
    users_to_skip_ids = []
    users_to_skip_ids << @author_id
    users_to_skip_ids.push(*@direct_users.pluck(:id).to_a)
    @nearby_places.each do |place|
      users = place.users.where.not(id: users_to_skip_ids).to_a
      @nearby_users.push(*users)
    end
  end
end

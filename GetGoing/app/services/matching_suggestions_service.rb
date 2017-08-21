# frozen_string_literal: true
# This class handles finding users for suggesting new posts in places they have visited/lived or near places they have visited/lived
class MatchingSuggestionsService
  attr_reader :direct_users, :nearby_users

  def initialize(params)
    if params[:post_id].present?
      @post = Post.find(params[:post_id])
      @direct_places = @post.places
      @author_id = @post.owner.id
    elsif params[:place]
      @direct_places = [params[:place]]
    elsif params[:places]
      @direct_places = params[:places]
    end
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
  end

  def find_direct_users
    @direct_places.each do |place|
      users = place.users.where.not(id: @author_id).to_a
      @direct_users.push(*users)
    end
    @direct_users.uniq!(&:id)
  end

  def find_nearby_users
    @nearby_places = find_nearby_places
    users_to_skip_ids = []
    users_to_skip_ids << @author_id
    users_to_skip_ids.push(*@direct_users.pluck(:id).to_a)
    @nearby_places.each do |place|
      users = place.users.where.not(id: users_to_skip_ids).to_a
      @nearby_users.push(*users)
    end
    @nearby_users.uniq!(&:id)
  end
end

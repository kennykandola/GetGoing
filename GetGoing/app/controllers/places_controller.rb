class PlacesController < ApplicationController
  before_action :authenticate_user!

  def index
    @places = current_user.places
  end

  def add_place_to_user
    @place = Place.where(google_place_id: params[:place][:google_place_id]).first
    if @place.blank?
      @place = Place.create(name: params[:place][:name],
                            google_place_id: params[:place][:google_place_id],
                            country: params[:place][:country])
    end
    PlaceUserRelation.create(place: @place, user: current_user, relation: 'traveled')
    @places = current_user.places
    respond_to :js
  end

  private

  def place_params
    params.require(:place).permit(:name, :google_place_id, :country)
  end

end

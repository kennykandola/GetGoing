class PlacesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def index
    @places = current_user.all_places
  end

  def add_place_to_user
    if params[:place][:google_place_id].present?
      @place = Place.where(google_place_id: params[:place][:google_place_id]).first
      if @place.blank?
        @place = Place.create(city: params[:place][:city],
                              state: params[:place][:state],
                              country: params[:place][:country],
                              google_place_id: params[:place][:google_place_id],
                              latitude: params[:place][:latitude],
                              longitude: params[:place][:longitude])
      end
      PlaceUserRelation.create(place: @place, user: current_user, relation: 'traveled')
    end
    @places = current_user.all_places
    respond_to :js
  end

  def set_as_current_location
    @place = Place.find(params[:id])
    current_user.location = @place
    @places = current_user.all_places
    respond_to :js
  end

  def set_as_hometown
    @place = Place.find(params[:id])
    current_user.hometown = @place
    @places = current_user.all_places
    respond_to :js
  end

  def destroy
    @place = Place.find(params[:id])
    PlaceUserRelation.where(place: @place, user: current_user).first.destroy
    @places = current_user.all_places
  end

  private

  def place_params
    params.require(:place).permit(:city, :state, :country, :google_place_id, :latitude, :longitude)
  end

  def set_user
    @user = current_user
  end
end

class BookingLinkTypesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_booking_link_type, only: [:edit, :update, :destroy]

  def index
    @booking_link_types = BookingLinkType.all
    authorize @booking_link_types
  end

  def new
    @booking_link_type = BookingLinkType.new
    authorize @booking_link_type
    respond_to :js
  end

  def create
    @booking_link_type = BookingLinkType.new(booking_link_type_params)
    authorize @booking_link_type
    @booking_link_type.save
    @booking_link_types = BookingLinkType.all
    respond_to :js
  end

  def edit
    authorize @booking_link_type
    respond_to :js
  end

  def update
    authorize @booking_link_type
    @booking_link_type.update(booking_link_type_params)
    @booking_link_types = BookingLinkType.all
    respond_to :js
  end

  def destroy
    authorize @booking_link_type
    @booking_link_type.destroy
    @booking_link_types = BookingLinkType.all
    respond_to :js
  end

  private

  def booking_link_type_params
    params.require(:booking_link_type).permit(:name, :url_type)
  end

  def set_booking_link_type
    @booking_link_type = BookingLinkType.find(params[:id])
  end
end

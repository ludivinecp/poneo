class ServicesController < ApplicationController
  before_action :authenticate_admin!, only: [:new, :create, :update, :edit, :destroy]
  before_action :authenticate_center!, only: [:edit, :update]
  before_action :authenticate_rider!

  def index
    if params[:search].present?
    # @centres = Centre.near(params[:search], params[:distance] || 50, order: :distance)
      @centres = Centre.near(params[:search], 50)
    else
      @centres = Centre.all
      @services = Service.all
    end

    @hash = Gmaps4rails.build_markers(@centres) do |centre, marker|
        marker.lat centre.latitude
        marker.lng centre.longitude
        marker.infowindow render_to_string(:partial => "/services/gmap", :locals => { :centre => centre})
        marker.picture({
          "url" => "http://people.mozilla.com/~faaborg/files/shiretoko/firefoxIcon/firefox-32.png",
          "width" => 32,
          "height" => 32
          })
      end
  end

  def show
    @service = Service.find(params[:id])
    @centre = Centre.find(params[:id])
    @booking = Booking.new

  end

  def new
    @service = Service.new
  end

  def edit
  end

  def create
    @service = Service.new(service_params)
    
      if @service.save
        format.html { redirect_to @service, notice: 'Service was successfully created.' }
        format.json { render :show, status: :created, location: @service }
      else
        format.html { render :new }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
  end

  def update
    respond_to do |format|
      if @service.update(service_params)
        format.html { redirect_to @service, notice: 'Service was successfully updated.' }
        format.json { render :show, status: :ok, location: @service }
      else
        format.html { render :edit }
        format.json { render json: @service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @service.destroy
    respond_to do |format|
      format.html { redirect_to services_url, notice: 'Service was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_service
      @service = Service.find(params[:id])
    end

    def service_params
      params[:service]
    end
end
require "open-uri"
require "will_paginate/array"

class WorkshopsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index show)
  before_action :set_workshop, only: %i(show edit update confirmation destroy)

  def index
    if params[:search].present?
      if params[:search][:starts_at].present? && params[:search][:ends_at].present?
        dates = (Date.strptime(params[:search][:starts_at], '%Y-%m-%d')..Date.strptime(params[:search][:ends_at], '%Y-%m-%d')).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } }
      elsif params[:search][:starts_at].present?
        dates = (Date.strptime(params[:search][:starts_at], '%Y-%m-%d')..Date.today + 3.months).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } }
      elsif params[:search][:ends_at].present?
        dates = (Date.today..Date.strptime(params[:search][:ends_at], '%Y-%m-%d')).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } }
      else
        @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true)
      end

      @workshops.paginate(page: params[:page], per_page: 20)

      @workshops = @workshops.select { |workshop| workshop.moments.include?(params[:search][:moment]) if workshop.moments != nil }.paginate(page: params[:page], per_page: 20) if params[:search][:moment].present?
      @workshops = @workshops.select { |workshop| workshop.thematic == params[:search][:keyword] }.paginate(page: params[:page], per_page: 20) if params[:search][:keyword].present?
      @workshops = @workshops.select { |workshop| workshop.place.district == params[:search][:place] || workshop.place.big_city == params[:search][:place] }.paginate(page: params[:page], per_page: 20) if params[:search][:place].present?
      @workshops = @workshops.select { |workshop| workshop.title.downcase.include?(params[:search][:selection]) }.paginate(page: params[:page], per_page: 20) if params[:search][:selection].present?
      @workshops = @workshops.select { |workshop| workshop.capacity >= params[:search][:min_capacity].to_i }.paginate(page: params[:page], per_page: 20) if params[:search][:min_capacity].present?
      @workshops = @workshops.select { |workshop| workshop.level == params[:search][:level] }.paginate(page: params[:page], per_page: 20) if params[:search][:level].present?

      if params[:search][:min_price].present? && params[:search][:max_price].present?

        min_price = params[:search][:min_price].to_f
        max_price = params[:search][:max_price].to_f

        if min_price > max_price
          @workshops = @workshops.select do |workshop|
            workshop.price <= min_price && workshop.price >= max_price
          end
          @workshops.paginate(page: params[:page], per_page: 20)
        elsif min_price == max_price
          @workshops = @workshops.select do |workshop|
            workshop.price == min_price
          end
          @workshops.paginate(page: params[:page], per_page: 20)
        else
          @workshops = @workshops.select do |workshop|
            workshop.price <= max_price && workshop.price >= min_price
          end
          @workshops.paginate(page: params[:page], per_page: 20)
        end

      elsif params[:search][:min_price].present?
        @workshops = @workshops.select do |workshop|
          workshop.price >= params[:search][:min_price].to_f
        end
        @workshops.paginate(page: params[:page], per_page: 20)

      elsif params[:search][:max_price].present?
        @workshops = @workshops.select do |workshop|
          workshop.price <= params[:search][:max_price].to_f
        end
        @workshops.paginate(page: params[:page], per_page: 20)
      end


      if params[:search][:ephemeral].present?
        if params[:search][:ephemeral] == 'false'
          @workshops = @workshops.select { |workshop| workshop.place.ephemeral == false }.paginate(page: params[:page], per_page: 20)
        end
      end

      if params[:search][:order].present?
        case params[:search][:order]
        when 'Recommandation'
          @workshops = @workshops.sort_by { |workshop| workshop.recommendable }.reverse.paginate(page: params[:page], per_page: 20)
        when 'Prix croissants'
          @workshops = @workshops.sort_by { |workshop| workshop.price }.paginate(page: params[:page], per_page: 20)
        when 'Prix décroissants'
          @workshops = @workshops.sort_by { |workshop| workshop.price }.reverse.paginate(page: params[:page], per_page: 20)
        when 'Les mieux notés'
          @workshops = @workshops.sort_by { |workshop| workshop.rating }.reverse.paginate(page: params[:page], per_page: 20)
        end
      end
    else
      @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).paginate(page: params[:page], per_page: 20)
    end
    # authorize @workshops

    @prices = policy_scope(Workshop).where(status: 'en ligne', db_status: true).map { |ws| ws.price }
    @min_price = @prices.present? ? @prices.min : 0
    @max_price = @prices.present? ? @prices.max : 120

    @places_geo = Place.where(id: @workshops.pluck(:place_id))

    @markers = @places_geo.map do |place|
      {
        lat: place.latitude,
        lng: place.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { place: place })
      }
    end

  end

  def show
    if @workshop
      @booking = Booking.new
      if @workshop.animators.present? && @workshop.animators.first.user.profile.db_status == true
        @animator = @workshop.animators.first
      end
    end
  end

  def edit
    if @workshop
      @places = current_user.admin ? Place.all.where(db_status: true) : current_user.places.where(db_status: true)
      @animators = Profile.where(role: 'animateur', db_status: true)
    end
  end

  def update
    @workshop.update(workshop_params)
    if @workshop.save
      flash[:notice] = "Votre atelier a bien été modifié !"
      redirect_to tableau_de_bord_profile_path(current_user.profile)
    else
      @places = current_user.admin ? Place.all.where(db_status: true) : current_user.places.where(db_status: true)
      render 'edit'
    end
  end

  def destroy
    ws_bookings = []
    @workshop.sessions.where(db_status: true).each do |session|
      if session.date >= Date.today - 7
        session.bookings.where(db_status: true).each do |booking|
          ws_bookings << booking
        end
      end
    end
    if ws_bookings.empty?
      @workshop.update(db_status: false)
      @workshop.save
    end
    redirect_back fallback_location: root_path
  end

  def new
    @workshop = Workshop.new
    authorize @workshop
    @places = current_user.admin ? Place.all.where(db_status: true) : current_user.places.where(db_status: true)
    @animators = Profile.where(role: 'animateur', db_status: true)
  end

  def create
    @workshop = Workshop.new(workshop_params)
    authorize @workshop
    @workshop.place = Place.friendly.find(params[:workshop][:place_id])
    @workshop.status = 'hors ligne'
    if @workshop.photos.attached? == false
      all_initial_ws = Workshop.all.select { |workshop| workshop.title == @workshop.title }
      if all_initial_ws.select { |workshop| workshop.place.user == @workshop.place.user }.present?
        initial_ws = all_initial_ws.select { |workshop| workshop.place.user == @workshop.place.user }.first
        initial_ws_files = []
        initial_ws.photos.each do |file|
          initial_ws_files << URI.open(file.service_url)
        end
        (0..initial_ws_files.size - 1).each do |i|
          @workshop.photos.attach([io: initial_ws_files[i], filename: initial_ws.photos[i].filename, content_type: initial_ws.photos[i].content_type])
        end
      end
    end
    if @workshop.save
      mail = WorkshopMailer.with(workshop: @workshop).create_confirmation
      mail.deliver_now
      flash[:notice] = "Votre atelier a bien été créé !"
      redirect_to confirmation_workshop_path(@workshop)
    else
      @places = current_user.admin ? Place.all.where(db_status: true) : current_user.places.where(db_status: true)
      render 'new'
    end
  end

  def confirmation
    if @workshop
      @users = User.all.where(db_status: true).select { |user| user.profile.role == 'animateur' }
      @animator = Animator.new
      @session = Session.new
    end
  end

  private

  def set_workshop
    if Workshop.friendly.find(params[:id]).db_status == true
      @workshop = Workshop.friendly.find(params[:id])
      authorize @workshop
    end
  end

  def workshop_params
    params.require(:workshop).permit(:title, :program, :final_product, :thematic, :level, :duration, :price, :status, :capacity, :recommendable, photos: [])
  end
end

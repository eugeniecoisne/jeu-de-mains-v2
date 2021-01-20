require "open-uri"
require "will_paginate/array"

class WorkshopsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(index show)
  before_action :set_workshop, only: %i(show edit update finalisation confirmation destroy)

  def index
    if params[:search].present?
      if params[:search][:starts_at].present? && params[:search][:ends_at].present?
        dates = (Date.strptime(params[:search][:starts_at], '%Y-%m-%d')..Date.strptime(params[:search][:ends_at], '%Y-%m-%d')).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.where(db_status: true).count > 0 }
      elsif params[:search][:starts_at].present?
        dates = (Date.strptime(params[:search][:starts_at], '%Y-%m-%d')..Date.today + 1.year).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.where(db_status: true).count > 0 }
      elsif params[:search][:ends_at].present?
        dates = (Date.today..Date.strptime(params[:search][:ends_at], '%Y-%m-%d')).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.where(db_status: true).count > 0 }
      else
        dates = (Date.today..Date.today + 1.year).to_a
        @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.where(db_status: true).count > 0 }
      end

      @workshops = @workshops.select { |workshop| workshop.moments.include?(params[:search][:moment]) if workshop.moments != nil }.paginate(page: params[:page], per_page: 20) if params[:search][:moment].present?
      @workshops = @workshops.select { |workshop| workshop.thematic == params[:search][:keyword] }.paginate(page: params[:page], per_page: 20) if params[:search][:keyword].present?
      @workshops = @workshops.select { |workshop| workshop.title.downcase.include?(params[:search][:selection]) }.paginate(page: params[:page], per_page: 20) if params[:search][:selection].present?
      @workshops = @workshops.select { |workshop| workshop.capacity >= params[:search][:min_capacity].to_i }.paginate(page: params[:page], per_page: 20) if params[:search][:min_capacity].present?
      @workshops = @workshops.select { |workshop| workshop.level == params[:search][:level] }.paginate(page: params[:page], per_page: 20) if params[:search][:level].present?

      # ajust results to map lat and long
      if params[:search][:minlatitude].present?
        lat_zone = (params[:search][:minlatitude].to_f..params[:search][:maxlatitude].to_f)
        long_zone = (params[:search][:minlongitude].to_f..params[:search][:maxlongitude].to_f)

        @workshops = @workshops.select do |w|
          long_zone.include?(w.place.longitude) && lat_zone.include?(w.place.latitude)
        end
        @workshops.paginate(page: params[:page], per_page: 20)
      elsif params[:search][:place].present?
        @workshops = @workshops.select { |workshop| workshop.place.district == params[:search][:place] || workshop.place.big_city == params[:search][:place] }.paginate(page: params[:page], per_page: 20)
      end

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
          @workshops = @workshops.where(ephemeral: false).paginate(page: params[:page], per_page: 20)
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
          @workshops = @workshops.sort_by { |workshop| workshop.rating.present? ? workshop.rating : 0 }.reverse.paginate(page: params[:page], per_page: 20)
        end
      else
        @workshops = @workshops.sort_by { |workshop| workshop.recommendable }.reverse.paginate(page: params[:page], per_page: 20)
      end
    else
      dates = (Date.today..Date.today + 1.year).to_a
      @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.where(db_status: true).count > 0 }.sort_by { |workshop| workshop.recommendable }.reverse.paginate(page: params[:page], per_page: 20)
    end
    # authorize @workshops

    @prices = policy_scope(Workshop).where(status: 'en ligne', db_status: true).map { |ws| ws.price }
    @max_price = @prices.present? ? @prices.max : 120

    @places_geo = Place.where(id: @workshops.pluck(:place_id)).select { |p| p.name.include?("Atelier en visio") == false}

    @markers = @places_geo.map do |place|
      {
        lat: place.latitude,
        lng: place.longitude,
        infoWindow: render_to_string(partial: "info_window", locals: { place: place })
      }
    end

    dates = (Date.today..Date.today + 1.year).to_a
    @suggested_workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 && workshop.recommendable >= 2 }.first(12)

  end

  def show
    if @workshop
      if (@workshop.db_status == true && @workshop.status == "en ligne") || @workshop.place.user == current_user || (@workshop.animators.where(db_status: true).last.user == current_user if @workshop.animators.where(db_status: true).present?) || current_user.admin?
        @booking = Booking.new
        if @workshop.animators.where(db_status: true).present? && @workshop.animators.last.user.profile.db_status == true
          @animator = @workshop.animators.where(db_status: true).last
        end
      else
        render :file => 'public/404.html', :status => :not_found, :layout => false
      end
    end
    dates = (Date.today..Date.today + 1.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.where(db_status: true).count > 0 && workshop.place.district == @workshop.place.district && workshop.thematic == @workshop.thematic }.sort_by { |workshop| workshop.recommendable }.first(6)
  end

  def edit
    if @workshop
      @places = current_user.admin ? Place.all.where(db_status: true) : current_user.places.where(db_status: true)
      @animators = Profile.where(db_status: true).select { |profile| profile.role.present? }
    end
  end

  def update
    @workshop.update(workshop_params)
    if params[:workshop][:place_id].present?
      @workshop.place = Place.find(params[:workshop][:place_id])
      @workshop.place.name == "Atelier en visio" ? @workshop.update(visio: true) : @workshop.update(visio: false)
    end
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
        session.bookings.where(db_status: true, status: "paid").each do |booking|
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
    @place = Place.new
    @places = current_user.admin ? Place.all.where(db_status: true) : current_user.places.where(db_status: true)
    @animators = Profile.where(db_status: true).select { |profile| profile.role.present? }
  end

  def create
    @workshop = Workshop.new(workshop_params)
    authorize @workshop
    @workshop.place = Place.find(params[:workshop][:place_id])
    @workshop.status = 'hors ligne'
    if @workshop.place.name == "Atelier en visio"
      @workshop.visio = true
    end
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
      mail.deliver_later
      flash[:notice] = "Votre atelier a bien été créé !"
      redirect_to finalisation_workshop_path(@workshop)
    else
      @places = current_user.admin ? Place.all.where(db_status: true) : current_user.places.where(db_status: true)
      render 'new'
    end
  end


  def finalisation
    if @workshop
      @users = User.all.where(db_status: true).select { |user| user.profile.role.present? && user != current_user }
      @animator = Animator.new
      @session = Session.new
    end
  end

  def confirmation
  end

  def send_verification_mail
    @workshop = Workshop.find(params[:id])
    authorize @workshop
    if @workshop && @workshop.completed? && @workshop.sessions.where(db_status: true).select { |session| session.date >= Date.today }.present?
      @workshop.update(status: "vérification")
      mail = WorkshopMailer.with(workshop: @workshop).ask_for_check_up
      mail.deliver_later
    else
      flash[:alert] = "Votre atelier ne peut être soumis à vérification. Vérifiez les champs et la présence d'une première date de session."
      redirect_back fallback_location: root_path
    end
  end

  def mark_as_verified_or_unverified
    if current_user.admin == true
      @workshop = Workshop.find(params[:verification][:workshop_id])
      authorize @workshop
      if params[:verification][:verified] == "true"
        @workshop.update(verified: true, status: "en ligne")
        mail = WorkshopMailer.with(workshop: @workshop, message: params[:verification][:message]).workshop_is_online
        mail.deliver_later
        redirect_to workshop_path(@workshop)
      else
        @workshop.update(status: "hors ligne")
        mail = WorkshopMailer.with(workshop: @workshop, message: params[:verification][:message]).workshop_cannot_be_online
        mail.deliver_later
        redirect_to workshop_path(@workshop)
      end
    else
      redirect_back fallback_location: root_path
    end
  end

  def invitation
    @workshop = Workshop.find(params[:invitation][:workshop_id])
    authorize @workshop
    if params[:invitation][:email].present?
      mail = WorkshopMailer.with(workshop: @workshop, email: params[:invitation][:email]).invite_partner
      mail.deliver_later
      flash[:notice] = "L'e-mail d'invitation a bien été envoyé à #{params[:invitation][:email]} !"
      redirect_to confirmation_workshop_path(@workshop)
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
    params.require(:workshop).permit(:title, :program, :final_product, :thematic, :level, :duration, :price, :status, :db_status, :capacity, :verified, :recommendable, :ephemeral, :kit, :kit_description, :visio, :slug, photos: [])
  end
end

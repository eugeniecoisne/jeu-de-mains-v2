class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(home offer_giftcard become_partner welcome_partner about contact legal_notice privacy_policy cgv autour_du_fil vegetal cosmetique_et_entretien bijou papier_et_lettering ceramique_et_modelage meuble_et_decoration dessin_et_peinture travail_du_cuir)

  def home
    dates = (Date.today..Date.today + 1.year).to_a
    @best_workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |w| w.dates.any? { |date| dates.include?(date) } && w.sessions.count > 0 && w.rating.present? }.sort_by { |w| w.rating }.reverse
    @last_minute = []
    Session.all.where(db_status: true).each do |session|
      if session.workshop.db_status == true && session.workshop.status == "en ligne"
        if session.date >= Date.today && session.available > 0
          @last_minute << session
        end
      end
    end
    @last_minute = @last_minute.sort_by { |session| session.date }
  end

  def autour_du_fil
    @thematic = {
      title: "Autour du fil",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1603214470/jeu-de-mains-autour-du-fil.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Autour du fil").select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }

  end

  def vegetal
    @thematic = {
      title: "Végétal",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1603214470/jeu-de-mains-vegetal.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Végétal").select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def papier_et_lettering
    @thematic = {
      title: "Papier & Lettering",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1603214470/jeu-de-mains-papier-lettering.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Papier & Lettering").select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def ceramique_et_modelage
    @thematic = {
      title: "Céramique & Modelage",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1603214470/jeu-de-mains-ceramique-modelage.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Céramique & Modelage").select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def bijou
    @thematic = {
      title: "Bijou",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1603214470/jeu-de-mains-bijou.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Bijou").select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def cosmetique_et_entretien
    @thematic = {
      title: "Cosmétique & Entretien",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1603214469/jeu-de-mains-cosmetique-entretien.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Cosmétique & Entretien").select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def dessin_et_peinture
    @thematic = {
      title: "Dessin & Peinture",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1603214470/jeu-de-mains-dessin-peinture.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Dessin & Peinture").select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def meuble_et_decoration
    @thematic = {
      title: "Meuble & Décoration",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1603214470/jeu-de-mains-meuble-decoration.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Meuble & Décoration").select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def travail_du_cuir
    @thematic = {
      title: "Travail du cuir",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1603379193/jeu-de-mains-travail-du-cuir.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Travail du cuir").select { |workshop| workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def become_partner
  end

  def welcome_partner
    if params[:partner].present? && params[:partner][:company].present? && params[:partner][:siret_number].present? && params[:partner][:email].present? && params[:partner][:phone_number].present? && params[:partner][:address].present? && params[:partner][:zip_code].present? && params[:partner][:city].present? && params[:partner][:last_name].present? && params[:partner][:first_name].present? && params[:partner][:position].present?
      # envoyer email à contact@jeudemains.com
      #
    else
      flash[:alert] = "Oups, le formulaire est incomplet"
      render 'become_partner'
    end
  end

  def offer_giftcard
  end

  def register_giftcard
    if params[:giftcard].present?
      if params[:giftcard][:code].present?
        @giftcard = Giftcard.find_by(code: params[:giftcard][:code])
        if @giftcard.receiver.present? == false
          @giftcard.update(user_id: current_user.id)
          @giftcard.update(receiver: current_user.id)
          @giftcard.save
          if params[:giftcard][:booking].present?
            redirect_back fallback_location: root_path
            flash[:notice] = "Votre carte cadeau a bien été enregistrée !"
          else
            redirect_to giftcard_confirmation_enregistrement_path(@giftcard)
          end
        else
          flash[:alert] = "Votre code est déjà utilisé ou erroné"
          redirect_back fallback_location: root_path
        end
      end
    end
  end

  def about
  end

  def contact
  end

  def legal_notice
  end

  def privacy_policy
  end

  def cgv
  end

end

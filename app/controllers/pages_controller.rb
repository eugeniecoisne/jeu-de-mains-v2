class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(home offer_giftcard register_giftcard become_partner welcome_partner entreprises about ranking contact contact_us_sent legal_notice privacy_policy cgv autour_du_fil vegetal cosmetique_et_entretien bijoux papier_et_calligraphie ceramique_et_modelage meuble_et_decoration peinture_et_dessin travail_du_cuir)

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
      introduction: "Envie d’apprendre à coudre vos propres vêtements, tricoter des chaussons pour bébé, décorer votre salon avec des coussins en punch needle, recycler des vêtements usagers en pièce unique et tendance ?
      Apprenez la couture, le tricot, le crochet, le macramé, la broderie, le punch needle, le string art et fabriquez vos propres créations grâce aux ateliers créatifs Jeu de Mains !",
      meta_description: "Apprenez couture, tricot, crochet, macramé, broderie, punch needle, string art et fabriquez vos propres créations grâce aux ateliers créatifs Jeu de Mains",
      meta_keywords: "atelier couture, atelier tricot, atelier broderie, cours de couture, atelier diy, atelier créatif, punch needle, crochet, customisation, reprisage, upcycling, atelier do it yourself, Jeu de Mains",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1614359376/jeu-de-mains-autour-du-fil.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.thematic.include?("Autour du fil") && workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }

  end

  def vegetal
    @thematic = {
      title: "Végétal",
      introduction:
      "Envie d’apprendre à confectionner votre couronne de fleurs, à décorer votre intérieur avec vos créations florales : herbier, bouquet de fleurs séchées, couronne de fleurs murale, cloche fleurie, bougie fleurie ou terrarium ?
      Apprenez les techniques d’art et création florale et fabriquez vos propres créations végétales grâce aux ateliers créatifs Jeu de Mains !",
      meta_description: "Apprenez l’art floral: couronne de fleurs, bouquet, fleurs séchées, cloche fleurie, bougie fleurie, herbier, terrarium grâce aux ateliers créatifs Jeu de Mains",
      meta_keywords: "atelier couronne de fleurs, atelier herbier, atelier diy, art floral, faire un bouquet, fleurs séchées, herbier, cloche fleurie, bougie fleurie, activité evjf, mariage, atelier do it yourself, Jeu de Mains",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1614360750/jeu-de-mains-vegetal.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.thematic.include?("Végétal") && workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def peinture_et_dessin
    @thematic = {
      title: "Peinture & Dessin",
      introduction: "Envie de vous emparer d’un pinceau ou crayon et de vous initier à la peinture ou au dessin ? Fleurs en aquarelle, peinture sur soie, peinture sur céramique, œuvre abstraite à l’acrylique, esquisse crayonnée… apprenez différentes techniques de peinture et dessin grâce aux ateliers créatifs Jeu de Mains !",
      meta_description: "Initiez-vous à la peinture et au dessin ou perfectionnez-vous grâce aux ateliers aquarelle, peinture sur soie, peinture sur céramique, dessin Jeu de Mains",
      meta_keywords: "atelier peinture, cours de peinture, aquarelle, peinture sur soie, peinture sur céramique, cours de dessin, atelier dessin, atelier do it yourself, Jeu de Mains",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1614360634/jeu-de-mains-peinture-et-dessin.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.thematic.include?("Peinture & Dessin") && workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def papier_et_calligraphie
    @thematic = {
      title: "Papier & Calligraphie",
      introduction: "Envie de créer votre bullet journal, confectionner votre moodboard ou visionboard, vous initier aux techniques calligraphiques du lettering, devenir imbattable en origami ? Découvrez les techniques d’art du papier, le scrapbooking et le lettering grâce aux ateliers créatifs Jeu de Mains !",
      meta_description: "Bullet journal, moodboard, papeterie fait-main, initiez-vous au scrapbooking et au lettering avec les ateliers créatifs Jeu de Mains",
      meta_keywords: "scrapbooking, lettering, calligraphie, atelier lettering, atelier bullet journal, atelier scrapbooking, art du papier, fabriquer papeterie, atelier do it yourself, Jeu de Mains",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1614359852/jeu-de-mains-papier-et-calligraphie.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.thematic.include?("Papier & Calligraphie") && workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def ceramique_et_modelage
    @thematic = {
      title: "Céramique & Modelage",
      introduction: "Envie de modeler une pièce d’art de la table en céramique, un porte-savon en ciment, un vase en poterie, une sculpture en argile ? Découvrez tout l’art du pétrissage, du tournage et du modelage et créez une pièce unique grâce aux ateliers de modelage Jeu de Mains !",
      meta_description: "Céramique, poterie : initiez-vous aux techniques de pétrissage, tournage et modelage de l’argile ou du béton avec les ateliers créatifs Jeu de Mains",
      meta_keywords: "céramique, cours de céramique, poterie, cours de poterie, atelier céramique, atelier poterie, atelier béton, modelage, sculpture, argile, béton, atelier do it yourself, Jeu de Mains",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1614359661/jeu-de-mains-ceramique-et-modelage.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.thematic.include?("Céramique & Modelage") && workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def bijoux
    @thematic = {
      title: "Bijoux",
      introduction: "Envie de vous parer de bijoux réalisés de vos mains ? Perles, pierres naturelles, chaînes et apprêts en plaqué or, doré à l’or fin, acier, laiton ou argent, plexiglas, pâte polymère : amusez-vous à créer des bijoux uniques qui vous ressemblent grâce aux ateliers de confection de bijoux Jeu de Mains !",
      meta_description: "Perles, pierres naturelles, apprêts en plaqué or, laiton ou argent: amusez-vous à créer des bijoux uniques avec les ateliers confection de bijoux Jeu de Mains",
      meta_keywords: "atelier création de bijoux, initiation création bijou, confectionner mes bijoux, bijoux fait-main, perles heishi, bijoux plaqué or, bijoux argent, bijoux laiton, bijoux diy, atelier do it yourself, Jeu de Mains",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1614359580/jeu-de-mains-bijoux.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.thematic.include?("Bijoux") && workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def cosmetique_et_entretien
    @thematic = {
      title: "Cosmétique & Entretien",
      introduction: "Envie d’apprendre à formuler vos propres cosmétiques naturelles et fabriquer vos produits d’entretien ménager ? Fabriquez un shampoing solide, un déodorant adapté pour votre peau, des produits zéro déchet, une crème visage naturelle, votre lessive, un spray nettoyant multi-usages plus sain grâce aux ateliers cosmétique et entretien Jeu de Mains !",
      meta_description: "Fabriquez des cosmétiques naturelles (shampoing, déodorant…) adaptées à votre peau et vos produits d’entretien ménager grâce aux ateliers Jeu de Mains",
      meta_keywords: "cosmétique naturelle, cosmétique maison, shampoing solide diy, lessive diy, déodorant diy, atelier cosmétique, atelier zéro déchet, diy nettoyant, spray nettoyant maison, atelier diy, atelier do it yourself, Jeu de Mains",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1614359941/jeu-de-mains-cosmetique-et-entretien.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.thematic.include?("Cosmétique & Entretien") && workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def travail_du_cuir
    @thematic = {
      title: "Travail du cuir",
      introduction: "Envie de découvrir les secrets de la maroquinerie ou de la cordonnerie ? Sac, porte-cartes, ceinture, gants, espadrilles, baskets, chaussures : apprenez les techniques de découpe, couture, assemblage et fabriquez une pièce unique que vous porterez avec fierté grâce aux ateliers de travail du cuir Jeu de Mains !",
      meta_description: "Sac, porte-cartes, espadrilles, baskets: fabriquez une pièce unique que vous porterez avec fierté avec les ateliers maroquinerie et cordonnerie Jeu de Mains",
      meta_keywords: "sac à main cuir diy, atelier diy sac cuir, confectionner sac, atelier travail du cuir, fabriquer mes baskets, atelier diy maroquinerie, fabriquer mon sac, atelier do it yourself, Jeu de Mains",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1614360516/jeu-de-mains-travail-du-cuir.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.thematic.include?("Travail du cuir") && workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def meuble_et_decoration
    @thematic = {
      title: "Meuble & Décoration",
      introduction: "Envie d’apporter une touche de décoration fait-main à votre intérieur ? Restauration de meuble, confection d’une suspension lumineuse unique, fabrication d’un meuble en bois sur-mesure, réalisation de petites décorations à thème Saint-Valentin, Pâques, Noël…  : découvrez et mettez en œuvre les étapes de conception grâce aux ateliers meuble et décoration Jeu de Mains !",
      meta_description: "Décorez votre intérieur avec du fait-main: restauration de meuble, fabrication de meuble en bois, petites déco à thèmes grâce aux ateliers créatifs Jeu de Mains",
      meta_keywords: "restauration de meuble, fabriquer mon meuble, fabrication objet en bois, décoration diy, suspension diy, décorations à thèmes diy, ateliers créatifs, ateliers diy, Jeu de Mains",
      image: "https://res.cloudinary.com/jeudemains/image/upload/v1614360068/jeu-de-mains-meuble-et-decoration.jpg"
    }
    dates = (Date.today..Date.today + 2.year).to_a
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true).select { |workshop| workshop.thematic.include?("Meuble & Décoration") && workshop.dates.any? { |date| dates.include?(date) } && workshop.sessions.count > 0 }
  end

  def become_partner
  end

  def welcome_partner
    if params[:partner].present? && params[:partner][:company].present? && params[:partner][:siret_number].present? && params[:partner][:email].present? && params[:partner][:phone_number].present? && params[:partner][:address].present? && params[:partner][:zip_code].present? && params[:partner][:city].present? && params[:partner][:last_name].present? && params[:partner][:first_name].present? && params[:partner][:position].present?

      @partner = {
        company: params[:partner][:company],
        siret_number: params[:partner][:siret_number],
        email: params[:partner][:email],
        phone_number: params[:partner][:phone_number],
        address: params[:partner][:address],
        zip_code: params[:partner][:zip_code],
        city: params[:partner][:city],
        role: params[:partner][:role],
        first_name: params[:partner][:first_name],
        last_name: params[:partner][:last_name],
        position: params[:partner][:position],
        website: params[:partner][:website],
        instagram: params[:partner][:instagram],
        message: params[:partner][:message],
      }
      internal_email = PartnerMailer.with(partner: @partner).internal_send_subscription_form
      internal_email.deliver_later
      external_email = PartnerMailer.with(partner: @partner).external_send_subscription_form
      external_email.deliver_later

    else
      flash[:alert] = "Oups, le formulaire est incomplet"
      render 'become_partner'
    end
  end

  def entreprises
  end

  def contact
  end

  def contact_us_sent
    if params[:contact_us].present? && params[:contact_us][:email].present? && params[:contact_us][:email].match(/^\S+@\S+\.\S+$/) != nil && params[:contact_us][:message].present? &&

      @contact = {
        email: params[:contact_us][:email],
        first_name: params[:contact_us][:first_name],
        last_name: params[:contact_us][:last_name],
        message: params[:contact_us][:message]
      }
      internal_email_contact_us = ContactMailer.with(contact: @contact).internal_send_contact_message
      internal_email_contact_us.deliver_later
      external_email_contact_us = ContactMailer.with(contact: @contact).external_send_contact_message
      external_email_contact_us.deliver_later
    else
      flash[:alert] = "Oups, le formulaire est incomplet ou votre e-mail est incorrect"
      render 'contact'
    end

  end

  def offer_giftcard
  end

  def register_giftcard
    if params[:giftcard].present?
      if params[:giftcard][:code].present?
        @giftcard = Giftcard.find_by(code: params[:giftcard][:code])
        if @giftcard && @giftcard.receiver.present? == false && @giftcard.status == "paid"
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

  def ranking
  end

  def legal_notice
  end

  def privacy_policy
  end

  def cgv
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "cgv-jdm-#{Date.today.strftime("%d-%m-%y")}"
      end
    end
  end

end

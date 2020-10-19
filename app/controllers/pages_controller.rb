class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(home partners about contact legal_notice privacy_policy cgv)

  def home
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true)
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

  def thematiques
  end

  def autour_du_fil
    @thematic = {
      title: "Autour du fil",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/eugeniedenis/image/upload/v1595540794/fil_xlyp6r.png"
    }
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Autour du fil")
  end

  def vegetal
    @thematic = {
      title: "Végétal",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/eugeniedenis/image/upload/v1595541463/vegetal_mimgof.png"
    }
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Végétal")
  end

  def papier_et_lettering
    @thematic = {
      title: "Papier & Lettering",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/eugeniedenis/image/upload/v1595540794/lettering_yk8m4e.png"
    }
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Papier & Lettering")
  end

  def ceramique_et_modelage
    @thematic = {
      title: "Céramique & Modelage",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/eugeniedenis/image/upload/v1595540794/ceramique_ctojra.png"
    }
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Céramique & Modelage")
  end

  def bijou
    @thematic = {
      title: "Bijou",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/eugeniedenis/image/upload/v1595540794/bijoux_qtzxio.png"
    }
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Bijou")
  end

  def cosmetique_et_entretien
    @thematic = {
      title: "Cosmétique & Entretien",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/eugeniedenis/image/upload/v1595540794/cosmetique_mdis6k.png"
    }
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Cosmétique & Entretien")

  end

  def dessin_et_peinture
    @thematic = {
      title: "Dessin & peinture",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/eugeniedenis/image/upload/v1595540795/peinture_dk64an.png"
    }
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Dessin & peinture")
  end

  def meuble_et_decoration
    @thematic = {
      title: "Meuble & Décoration",
      introduction: "Duis tortor sem, ultrices in fermentum vel, congue vitae urna. Etiam dignissim leo et mauris dignissim, id tincidunt eros consectetur. Phasellus tellus ligula, faucibus ac pulvinar in, feugiat scelerisque dolor. Maecenas pharetra arcu eu orci malesuada aliquet.",
      image: "https://res.cloudinary.com/eugeniedenis/image/upload/v1595540794/brico_r8wbwg.png"
    }
    @workshops = policy_scope(Workshop).where(status: 'en ligne', db_status: true, thematic: "Meuble & Décoration")
  end

  def partners
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

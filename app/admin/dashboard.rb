ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  action_item "Créer un membre" do
    link_to("Créer un membre", new_admin_user_path, class: :button)
  end

  action_item "Compléter un profil" do
    link_to("Compléter un profil", new_admin_profile_path, class: :button)
  end

  action_item "Créer un lieu" do
    link_to("Créer un lieu", new_admin_place_path, class: :button)
  end

  action_item "Créer un atelier" do
    link_to("Créer un atelier", new_admin_workshop_path, class: :button)
  end

  action_item "Ajouter un animateur à un atelier" do
    link_to("Ajouter un animateur à un atelier", new_admin_animator_path, class: :button)
  end

  action_item "Créer une session" do
    link_to("Créer une session", new_admin_session_path, class: :button)
  end


  content title: proc { I18n.t("active_admin.dashboard") } do

    h2 "FICHES"
    columns do

     # LES UTILISATEURS MEMBRES

      column do
        h4 "MEMBRES BtoC"

        panel "MEMBRES BtoC" do
          h2 "#{User.all.select { |u| u.confirmed? && u.db_status == true && u.profile.role.nil? }.count}"
        end
        panel "NOUVEAUX MEMBRES BtoC" do
          columns do
            column do
              para "7 jrs"
              h2 "#{User.all.select { |u| u.confirmed_at > (Date.today - 7.day) && u.db_status == true && u.profile.role.nil? }.count}"
            end
            column do
              para "30 jrs"
              h2 "#{User.all.select { |u| u.confirmed_at > (Date.today - 30.day) && u.db_status == true && u.profile.role.nil? }.count}"
            end
            column do
              para "Début"
              h2 "#{User.all.select { |u| u.confirmed? && u.db_status == true && u.profile.role.nil? }.count}"
            end
          end
        end
        panel "DÉSINSCRIPTIONS BtoC" do
          columns do
            column do
              para "7 jrs"
              h2 "#{User.all.select { |u| u.db_status == false && u.updated_at > (Date.today - 7.day) && u.profile.role.nil? }.count}"
            end
            column do
              para "30 jrs"
              h2 "#{User.all.select { |u| u.db_status == false && u.updated_at > (Date.today - 30.day) && u.profile.role.nil? }.count}"
            end
            column do
              para "Début"
              h2 "#{User.all.select { |u| u.db_status == false && u.profile.role.nil? }.count}"
            end
          end
        end
      end


      # LES PARTENAIRES B TO B

      column do
        h4 "PARTENAIRES"

        panel "PARTENAIRES" do
          h2 "#{Profile.all.where(db_status: true).select { |p| p.role.present? }.count}"
        end
        panel "BOUTIQUES / ATELIERS" do
          h2 "#{Profile.all.where(db_status: true).select { |p| p.role == "boutique / atelier" }.count}"
        end
        panel "ANIMATEURS D'ATELIERS" do
          h2 "#{Profile.all.where(db_status: true).select { |p| p.role == "animation d'ateliers" }.count}"
        end
        panel "EVENEMENTIEL" do
          h2 "#{Profile.all.where(db_status: true).select { |p| p.role == "événementiel" }.count}"
        end

      end


      # LES ATELIERS EN LIGNE

      column do
        h4 "ATELIERS"

        dates = (Date.today..Date.today + 2.year).to_a
        ws_to_come = Workshop.all.where(status: 'en ligne', db_status: true).select { |w| w.dates.any? { |d| dates.include?(d) } && w.sessions.count > 0 }
        ws_by_rating = Workshop.all.where(status: 'en ligne', db_status: true).select { |w| w.dates.any? { |d| dates.include?(d) } && w.sessions.count > 0 && w.rating.present? }.sort_by { |w| w.rating }

        panel "ATELIERS EN LIGNE" do
          h2 "#{ws_to_come.count}"
        end
        panel "TOP 5 ATELIERS EN LIGNE" do
          ul do
            ws_by_rating.reverse.first(5).map do |w|
              li link_to("#{w.id} - #{w.title} - #{w.rating}/ 5", admin_workshop_path(w))
            end
          end
        end
        panel "FLOP 5 ATELIERS EN LIGNE" do
          ul do
            ws_by_rating.first(5).map do |w|
              li link_to("#{w.id} - #{w.title} - #{w.rating}/ 5", admin_workshop_path(w))
            end
          end
        end
      end

      # LES PARTENAIRES TOP / FLOP

      column do
        h4 "PARTENAIRES TOP / FLOP"
        partner_by_rating = Profile.all.where(db_status: true).select { |p| p.role.present? && p.rating != nil && p.rating > 0 }.sort_by { |p| p.rating }

        panel "PARTENAIRES" do
          h2 "#{Profile.all.where(db_status: true).select { |p| p.role.present? }.count}"
        end
        panel "TOP 5 PARTENAIRES" do
          ul do
            partner_by_rating.reverse.first(5).map do |p|
              li link_to("#{p.id} - #{p.company} - #{p.rating}/ 5", admin_profile_path(p))
            end
          end
        end
        panel "FLOP 5 PARTENAIRES" do
          ul do
            partner_by_rating.first(5).map do |p|
              li link_to("#{p.id} - #{p.company} - #{p.rating}/ 5", admin_profile_path(p))
            end
          end
        end
      end

      # LES SESSIONS

      column do
        h4 "SESSIONS"

        sessions_to_come = Session.all.where(db_status: true).select { |s| s.date >= Date.today && s.workshop.status == "en ligne" }
        passed_sessions = Session.all.select { |s| s.bookings.where(db_status: true, status: "paid").present? == true }.select { |s| s.bookings.where(db_status: true, status: "paid").count > 0 && s.date < Date.today }

        panel "SESSIONS EN LIGNE" do
          h2 "#{sessions_to_come.count}"
        end

        panel "SESSIONS RÉALISÉES" do
          columns do
            column do
              para "7 jrs"
              h2 "#{Session.all.select { |s| s.bookings.where(db_status: true, status: "paid").present? == true }.select { |s| s.bookings.where(db_status: true, status: "paid").count > 0 && s.date < Date.today && s.date > (Date.today - 7.day) }.count }"
            end
            column do
              para "30 jrs"
              h2 "#{Session.all.select { |s| s.bookings.where(db_status: true, status: "paid").present? == true }.select { |s| s.bookings.where(db_status: true, status: "paid").count > 0 && s.date < Date.today && s.date > (Date.today - 30.day) }.count }"
            end
            column do
              para "Début"
              h2 "#{Session.all.select { |s| s.bookings.where(db_status: true, status: "paid").present? == true }.select { |s| s.bookings.where(db_status: true, status: "paid").count > 0 && s.date < Date.today }.count }"
            end
          end
        end

        panel "SESSIONS ANNULÉES OU SANS PARTICIPANT" do
          columns do
            column do
              para "7 jrs"
              h2 "#{Session.all.select { |s| s.date < Date.today && s.date > Date.today - 7.day }.select { |s| s.bookings.where(db_status: true, status: "paid").count == 0 || s.reason.present? == true }.count }"
            end
            column do
              para "30 jrs"
              h2 "#{Session.all.select { |s| s.date < Date.today && s.date > Date.today - 30.day }.select { |s| s.bookings.where(db_status: true, status: "paid").count == 0 || s.reason.present? == true }.count }"
            end
            column do
              para "Début"
              h2 "#{Session.all.select { |s| s.date < Date.today }.select { |s| s.bookings.where(db_status: true, status: "paid").count == 0 || s.reason.present? == true }.count }"
            end
          end
        end

        panel "SESSIONS ANNULÉES PAR LE PARTENAIRE" do
          columns do
            column do
              para "7 jrs"
              h2 "#{Session.all.select { |s| s.date < Date.today && s.date > Date.today - 7.day }.select { |s| s.reason.present? == true }.count }"
            end
            column do
              para "30 jrs"
              h2 "#{Session.all.select { |s| s.date < Date.today && s.date > Date.today - 30.day }.select { |s| s.reason.present? == true }.count }"
            end
            column do
              para "Début"
              h2 "#{Session.all.select { |s| s.date < Date.today }.select { |s| s.reason.present? == true }.count }"
            end
          end
        end
      end
    end


    h2 "ACHATS"
    columns do

     # LES RÉSERVATIONS

      column do
        h4 "RÉSERVATIONS D'ATELIERS"

        panel "RÉSERVATIONS" do

          columns do
            column do
              para "7 jrs"
              bookings_7_sum = 0
              Booking.all.where(db_status: true, status: "paid").select { |b| b.created_at > (Date.today - 7.day)}.each { |b| bookings_7_sum += b.quantity }
              h2 "#{bookings_7_sum}"
            end
            column do
              para "30 jrs"
              bookings_30_sum = 0
              Booking.all.where(db_status: true, status: "paid").select { |b| b.created_at > (Date.today - 30.day)}.each { |b| bookings_30_sum += b.quantity }
              h2 "#{bookings_30_sum}"
            end
            column do
              para "Début"
              bookings_sum = 0
              Booking.all.where(db_status: true, status: "paid").each { |b| bookings_sum += b.quantity }
              h2 "#{bookings_sum}"
            end
          end
        end
        panel "ANNULATIONS" do
          columns do
            column do
              para "7 jrs"
              cancel_bookings_7_sum = 0
              Booking.all.where(db_status: true, status: "refunded").select { |b| b.cancelled_at > (Date.today - 7.day) if b.cancelled_at}.each { |b| cancel_bookings_7_sum += b.quantity }
              h2 "#{cancel_bookings_7_sum}"
            end
            column do
              para "30 jrs"
              cancel_bookings_30_sum = 0
              Booking.all.where(db_status: true, status: "refunded").select { |b| b.cancelled_at > (Date.today - 30.day) if b.cancelled_at}.each { |b| cancel_bookings_30_sum += b.quantity }
              h2 "#{cancel_bookings_30_sum}"
            end
            column do
              para "Début"
              cancel_bookings_sum = 0
              Booking.all.where(db_status: true, status: "refunded").each { |b| cancel_bookings_sum += b.quantity }
              h2 "#{cancel_bookings_sum}"
            end
          end
        end
      end

      # LES CARTES CADEAUX

      column do
        h4 "CARTES CADEAUX"

        panel "ACHAT DE CARTE CADEAU" do
          columns do
            column do
              para "7 jrs"
              giftcards_7 = Giftcard.all.where(db_status: true, status: "paid").select { |g| g.created_at > (Date.today - 7.day)}
              h2 "#{giftcards_7.count}"
            end
            column do
              para "30 jrs"
              giftcards_30 = Giftcard.all.where(db_status: true, status: "paid").select { |g| g.created_at > (Date.today - 30.day)}
              h2 "#{giftcards_30.count}"
            end
            column do
              para "Début"
              giftcards = Giftcard.all.where(db_status: true, status: "paid")
              h2 "#{giftcards.count}"
            end
          end
        end
        panel "CARTE DE 20 à 40€" do
          columns do
            column do
              para "7 jrs"
              giftcards_7 = Giftcard.all.where(db_status: true, status: "paid").select { |g| g.created_at > (Date.today - 7.day) && [20, 30, 40].include?(g.amount.to_i)}
              h2 "#{giftcards_7.count}"
            end
            column do
              para "30 jrs"
              giftcards_30 = Giftcard.all.where(db_status: true, status: "paid").select { |g| g.created_at > (Date.today - 30.day) && [20, 30, 40].include?(g.amount.to_i)}
              h2 "#{giftcards_30.count}"
            end
            column do
              para "Début"
              giftcards = Giftcard.all.where(db_status: true, status: "paid").select { |g| [20, 30, 40].include?(g.amount.to_i)}
              h2 "#{giftcards.count}"
            end
          end
        end
        panel "CARTE DE 50 à 70€" do
          columns do
            column do
              para "7 jrs"
              giftcards_7 = Giftcard.all.where(db_status: true, status: "paid").select { |g| g.created_at > (Date.today - 7.day) && [50, 60, 70].include?(g.amount.to_i)}
              h2 "#{giftcards_7.count}"
            end
            column do
              para "30 jrs"
              giftcards_30 = Giftcard.all.where(db_status: true, status: "paid").select { |g| g.created_at > (Date.today - 30.day) && [50, 60, 70].include?(g.amount.to_i)}
              h2 "#{giftcards_30.count}"
            end
            column do
              para "Début"
              giftcards = Giftcard.all.where(db_status: true, status: "paid").select { |g| [50, 60, 70].include?(g.amount.to_i)}
              h2 "#{giftcards.count}"
            end
          end
        end
        panel "CARTE DE 80 à 100€" do
          columns do
            column do
              para "7 jrs"
              giftcards_7 = Giftcard.all.where(db_status: true, status: "paid").select { |g| g.created_at > (Date.today - 7.day) && [80, 90, 100].include?(g.amount.to_i)}
              h2 "#{giftcards_7.count}"
            end
            column do
              para "30 jrs"
              giftcards_30 = Giftcard.all.where(db_status: true, status: "paid").select { |g| g.created_at > (Date.today - 30.day) && [80, 90, 100].include?(g.amount.to_i)}
              h2 "#{giftcards_30.count}"
            end
            column do
              para "Début"
              giftcards = Giftcard.all.where(db_status: true, status: "paid").select { |g| [80, 90, 100].include?(g.amount.to_i)}
              h2 "#{giftcards.count}"
            end
          end
        end
        panel "CARTE DE 110 à 150€" do
          columns do
            column do
              para "7 jrs"
              giftcards_7 = Giftcard.all.where(db_status: true, status: "paid").select { |g| g.created_at > (Date.today - 7.day) && [110, 120, 130, 140, 150].include?(g.amount.to_i)}
              h2 "#{giftcards_7.count}"
            end
            column do
              para "30 jrs"
              giftcards_30 = Giftcard.all.where(db_status: true, status: "paid").select { |g| g.created_at > (Date.today - 30.day) && [110, 120, 130, 140, 150].include?(g.amount.to_i)}
              h2 "#{giftcards_30.count}"
            end
            column do
              para "Début"
              giftcards = Giftcard.all.where(db_status: true, status: "paid").select { |g| [110, 120, 130, 140, 150].include?(g.amount.to_i)}
              h2 "#{giftcards.count}"
            end
          end
        end
      end
    end


    h2 "AVIS"

    columns do

      column do

        panel "AVIS POSTÉS" do

          columns do
            column do
              para "7 jrs"
              reviews_7 = Review.all.where(db_status: true).select { |r| r.created_at > (Date.today - 7.day)}
              h2 "#{reviews_7.count}"
            end
            column do
              para "30 jrs"
              reviews_30 = Review.all.where(db_status: true).select { |r| r.created_at > (Date.today - 30.day)}
              h2 "#{reviews_30.count}"
            end
            column do
              para "Début"
              reviews = Review.all.where(db_status: true)
              h2 "#{reviews.count}"
            end
          end
        end
      end

      column do

        panel "MOYENNE GLOBALE DES AVIS" do

          columns do
            column do
              para "7 jrs"
              sum_ratings_7 = 0
              nb_ratings_7 = 0
              Review.all.where(db_status: true).select { |r| r.created_at > (Date.today - 7.day)}.each do |r|
                sum_ratings_7 += r.rating
                nb_ratings_7 += 1
              end
              h2 "#{(sum_ratings_7.to_f / nb_ratings_7.to_f).round(2)}"
            end
            column do
              para "30 jrs"
              sum_ratings_30 = 0
              nb_ratings_30 = 0
              Review.all.where(db_status: true).select { |r| r.created_at > (Date.today - 30.day)}.each do |r|
                sum_ratings_30 += r.rating
                nb_ratings_30 += 1
              end
              h2 "#{(sum_ratings_30.to_f / nb_ratings_30.to_f).round(2)}"
            end
            column do
              para "Début"
              sum_ratings = 0
              nb_ratings = 0
              Review.all.where(db_status: true).each do |r|
                sum_ratings += r.rating
                nb_ratings += 1
              end
              h2 "#{(sum_ratings.to_f / nb_ratings.to_f).round(2)}"
            end
          end
        end
      end

      column do

        panel "NB AVIS / NB RÉSERVATIONS" do

          columns do
            column do
              para "7 jrs"
              reviews_7 = Review.all.where(db_status: true).select { |r| r.created_at > (Date.today - 7.day)}
              bookings_7_sum = 0
              Booking.all.where(db_status: true).select { |b| b.created_at > (Date.today - 7.day)}.each { |b| bookings_7_sum += b.quantity }
              if bookings_7_sum > 0
                h2 "#{ (reviews_7.count.to_f / bookings_7_sum * 100.0).round(2) }%"
              else
                h2 "NaN"
              end
            end
            column do
              para "30 jrs"
              reviews_30 = Review.all.where(db_status: true).select { |r| r.created_at > (Date.today - 30.day)}
              bookings_30_sum = 0
              Booking.all.where(db_status: true).select { |b| b.created_at > (Date.today - 30.day)}.each { |b| bookings_30_sum += b.quantity }
              if bookings_30_sum > 0
                h2 "#{ (reviews_30.count.to_f / bookings_30_sum * 100.0).round(2) }%"
              else
                h2 "NaN"
              end
            end
            column do
              para "Début"
              reviews = Review.all.where(db_status: true)
              bookings_sum = 0
              Booking.all.where(db_status: true).each { |b| bookings_sum += b.quantity }
              if bookings_sum > 0
                h2 "#{ (reviews.count.to_f / bookings_sum * 100.0).round(2) }%"
              else
                h2 "NaN"
              end
            end
          end
        end
      end
    end

    h2 "CHAT B TO B"

    columns do

      column do

        panel "MESSAGES ÉCHANGÉS" do

          columns do
            column do
              para "7 jrs"
              messages_7 = Message.all.select { |m| m.created_at > (Date.today - 7.day)}
              h2 "#{messages_7.count}"
            end
            column do
              para "30 jrs"
              messages_30 = Message.all.select { |m| m.created_at > (Date.today - 30.day)}
              h2 "#{messages_30.count}"
            end
            column do
              para "Début"
              messages = Message.all
              h2 "#{messages.count}"
            end
          end
        end
      end

      column do

        panel "CONVERSATIONS ENGAGÉES" do

          columns do
            column do
              para "7 jrs"
              chatrooms_7 = Chatroom.all.select { |c| c.created_at > (Date.today - 7.day)}
              h2 "#{chatrooms_7.count}"
            end
            column do
              para "30 jrs"
              chatrooms_30 = Chatroom.all.select { |c| c.created_at > (Date.today - 30.day)}
              h2 "#{chatrooms_30.count}"
            end
            column do
              para "Début"
              chatrooms = Chatroom.all
              h2 "#{chatrooms.count}"
            end
          end
        end
      end
    end
  end
end

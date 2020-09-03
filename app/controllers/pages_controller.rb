class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(home partners about contact legal_notice privacy_policy cgv)

  def home
    @workshops = policy_scope(Workshop).where(status: 'en ligne')
    @last_minute = []
    Session.all.each do |session|
      if session.date >= Date.today && session.available > 0
        @last_minute << session
      end
    end
    @last_minute = @last_minute.sort_by { |session| session.date }
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

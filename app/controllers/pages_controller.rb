class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i(home partners about contact legal_notice privacy_policy cgv)

  def home
    @workshops = policy_scope(Workshop).where(status: 'en ligne')
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

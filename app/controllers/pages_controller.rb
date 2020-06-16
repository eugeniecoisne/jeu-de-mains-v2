class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    @workshops = policy_scope(Workshop).where(status: 'en ligne')
  end

end

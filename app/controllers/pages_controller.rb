class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home, :partners]

  def home
    @workshops = policy_scope(Workshop).where(status: 'en ligne')
  end

  def partners
  end

end

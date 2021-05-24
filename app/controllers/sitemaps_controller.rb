class SitemapsController < ApplicationController
  skip_before_action :authenticate_user!

  def sitemap
    @workshops = Workshop.all.where(db_status: true, status: "en ligne")
    @partners = Profile.all.where(db_status: true, ready: true).select { |p| p.role.present? }
    respond_to do |format|
      format.xml
    end
  end
end

class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  include Pundit

  # Pundit: white-list approach.
  after_action :verify_authorized, except: :index, unless: :skip_pundit?
  after_action :verify_policy_scoped, only: :index, unless: :skip_pundit?

  # Uncomment when you *really understand* Pundit!
  # rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  # def user_not_authorized
  #   flash[:alert] = "You are not authorized to perform this action."
  #   redirect_to(root_path)
  # end

  before_action :configure_permitted_parameters, if: :devise_controller?

  after_action :store_location

  def store_location
    # store last url - this is needed for post-login redirect to whatever the user last visited.
    if (request.fullpath != "/connexion" &&
        request.fullpath != "/inscription" &&
        request.fullpath != "/users/confirmation?" &&
        request.fullpath != "/users/passwords" &&
        request.fullpath.include?("search-places") == false &&
        request.fullpath != "/deconnexion" &&
        !request.xhr?) # don't store ajax calls
      session["user_return_to"] = request.fullpath
    end
  end

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :created_by_admin, :newsletter_agreement, :cgu_agreement])
    devise_parameter_sanitizer.permit(:account_update, keys: [:first_name, :last_name, :created_by_admin, :newsletter_agreement, :cgu_agreement])
  end

  private

  def skip_pundit?
    devise_controller? || params[:controller] =~ /(^(rails_)?admin)|(^pages$)/
  end
end

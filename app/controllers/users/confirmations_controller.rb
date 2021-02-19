class Users::ConfirmationsController < Devise::ConfirmationsController
  def show
    super do |resource|
      sign_in(resource)
    end
  end

  protected

  def after_confirmation_path_for(resource_name, resource)
    if signed_in?(resource_name)
      stored_location_for(resource)
    else
      new_session_path(resource_name)
    end
  end
end

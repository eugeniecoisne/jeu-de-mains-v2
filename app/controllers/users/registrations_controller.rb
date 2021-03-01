class Users::RegistrationsController < Devise::RegistrationsController

  def destroy
    resource.update(db_status: false)
    Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    set_flash_message! :notice, :destroyed
    respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
  end

  protected

  def after_sign_up_path_for(resource)
    stored_location_for(resource) || root_path
  end

   def after_inactive_sign_up_path_for(resource)
    stored_location_for(resource) || root_path
  end
end

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"].except(:extra) # Removing extra as it can overflow some session stores
      redirect_back fallback_location: root_path
    end
  end

  def google_oauth2
    @user = User.from_omniauth(request.env['omniauth.auth'])

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Google") if is_navigational_format?
    else
      session['devise.google_data'] = request.env['omniauth.auth'].except(:extra) # Removing extra as it can overflow some session stores
      redirect_back fallback_location: root_path
    end
  end

  def stripe_connect
    auth_data = request.env["omniauth.auth"]
    @user = current_user
    if @user.persisted?
      @user.stripe_provider = auth_data.provider
      @user.stripe_uid = auth_data.uid
      @user.access_code = auth_data.credentials.token
      @user.publishable_key = auth_data.info.stripe_publishable_key
      @user.save

      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Stripe Connect") if is_navigational_format?
    else
      session["devise.stripe_connect_data"] = request.env['omniauth.auth']
      redirect_back fallback_location: root_path
    end

  end

  def failure
    redirect_to root_path
  end
end

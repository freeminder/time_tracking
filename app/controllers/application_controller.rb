# frozen_string_literal: true

# Application base controller
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  skip_before_action :verify_authenticity_token
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def not_found
    render file: "#{Rails.root}/public/404.html", status: :not_found
  end

  def authorize_admin
    redirect_to root_path, alert: 'Access Denied' unless current_user.admin?
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i[email password password_confirmation first_name last_name rate])
    devise_parameter_sanitizer.permit(:sign_in, keys: %i[email password remember_me])
    devise_parameter_sanitizer.permit(:sign_out, keys: %i[email password])
    devise_parameter_sanitizer.permit(:account_update, keys: %i[email password password_confirmation current_password])
  end

  private

  def after_sign_out_path_for(*)
    root_path
  end
end

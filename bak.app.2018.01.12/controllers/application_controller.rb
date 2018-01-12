class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  include ApplicationHelper

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) do |user_params|
    	user_params.permit({ roles: [] }, :email, :password, :password_confirmation, :login_id, :realname, :product_line)
    end
  end
end

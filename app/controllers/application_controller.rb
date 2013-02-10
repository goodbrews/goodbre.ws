class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  protected

    def handle_unverified_request
      super
      cookies.delete(:auth_token)
      @current_user = nil
    end

  private

    def current_user
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    end

    def signed_in?
      !!current_user
    end

    helper_method :current_user, :signed_in?

    def ensure_signed_in!
      redirect_to sign_in_account_path, :alert => 'Please sign in to continue.' unless signed_in?
    end

    def ensure_admin!
      current_user.admin?
    end
end

class AuthenticationController < ApplicationController
  # GET /account/sign_in
  def sign_in
  end

  # POST /account/sign_in
  def authenticate
    user = User.find_by_login(params[:login])

    if user && user.authenticate(params[:password])
      cookies.permanent[:auth_token] = user.auth_token
      # redirect_to
    else
      redirect_to sign_in_account_path, :notice => 'Invalid login/password combination'
    end
  end

  # POST /account/sign_out
  def sign_out
    cookies.delete(:auth_token)
    redirect_to root_path
  end
end

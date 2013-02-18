class AccountController < ApplicationController
  before_filter :ensure_signed_in!, only: [:edit, :update, :destroy]
  # GET /account/new
  def new
    @user = User.new
  end

  # POST /account
  def create
    @user = User.new(user_params)

    if @user.save
      cookies.permanent[:auth_token] = @user.auth_token
      redirect_to root_path, notice: 'Welcome to goodbre.ws!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  # GET /account/settings
  def edit
  end

  # PUT /account
  def update
    unless current_user.authenticate(user_params[:current_password])
      current_user.errors.add(:current_password, 'was incorrect')
      render :edit and return
    end

    if current_user.update_attributes(user_params)
      redirect_to dashboard_path
    else
      render :edit
    end
  end

  # DELETE /account
  def destroy
    current_user.destroy
    cookies.delete(:auth_token)
    redirect_to welcome_path, notice: 'Come back some day!'
  end

  private
    def user_params
      params.require(:user).permit(:email, :name, :city, :region, :country, :password, :password_confirmation, :current_password)
    end
end

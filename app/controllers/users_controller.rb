class UsersController < ApplicationController
  before_filter :load_user

  # GET /users/:id
  # GET /users/:id/likes
  def show
    @beers = @user.liked_beers.includes(:breweries, :style)
  end

  # GET /users/:id/dislikes
  def dislikes
    @beers = @user.disliked_beers.includes(:breweries, :style)
  end

  # GET /users/:id/fridge
  def fridge
    @beers = @user.bookmarked_beers.includes(:breweries, :style)
  end

  # GET /users/:id/similar
  def similar
    @users = @user.similar_raters # Returns 10 by default.
  end

  private
    def load_user
      @user = User.from_param(params[:id])
    end
end

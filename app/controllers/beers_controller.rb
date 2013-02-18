class BeersController < ApplicationController
  RECOMMENDABLE_METHODS = %w[like unlike dislike undislike hide unhide bookmark unbookmark]

  before_filter :ensure_signed_in!
  respond_to :html, only: [:index, :show]
  respond_to :json, only: RECOMMENDABLE_METHODS

  # GET /beers
  def index
    @beers = Beer.includes(:breweries, :style)

    # app/views/beers/index.html.haml
  end

  # GET /breweries/:brewery_id/beers/:id
  def show
    @brewery = Brewery.find(params[:brewery_id])
    @beer = @brewery.beers.includes(:breweries, :style).find(params[:id])

    # app/views/beers/show.html.haml
  end

  # POST/DELETE /beers/:id/like.json
  # POST/DELETE /beers/:id/dislike.json
  # POST/DELETE /beers/:id/hide.json
  # POST/DELETE /beers/:id/bookmark.json
  RECOMMENDABLE_METHODS.each do |method|
    define_method(method) do
      @beer = Beer.find(params[:id])

      if current_user.send(method, @beer)
        head :ok
      else
        head :unprocessable_entity
      end
    end
  end
end

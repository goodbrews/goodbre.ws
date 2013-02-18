class BreweriesController < ApplicationController
  # GET /breweries
  def index
    @breweries = Brewery.includes(beers: [:breweries, :styles])

    # app/views/breweries/index.html.haml
  end

  # GET /breweries/:id
  def show
    @brewery = Brewery.includes(:beers).from_param(params[:id])
    @beers = @brewery.beers.includes(:breweries, :style).order(:name)

    # app/views/breweries/show.html.haml
  end
end

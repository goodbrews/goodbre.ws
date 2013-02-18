class BreweriesController < ApplicationController
  # GET /breweries
  def index
    @breweries = Brewery.includes(beers: [:breweries, :styles])

    # app/views/breweries/index.html.haml
  end

  # GET /breweries/search
  def search
    @breweries = Brewery.includes(beers: [:breweries, :style]).search(params[:q])
  end

  # GET /breweries/:id
  def show
    @brewery = Brewery.includes(beers: [:breweries, :style]).from_param(params[:id])
    @beers = @brewery.beers.order(:name)

    # app/views/breweries/show.html.haml
  end
end

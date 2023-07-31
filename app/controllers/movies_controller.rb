class MoviesController < ApplicationController
  def index
    @movies = if params[:search]
                Movie.search(params[:search])
              else
                Movie.all
              end
  end
end

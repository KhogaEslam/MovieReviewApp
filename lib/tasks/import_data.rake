require 'csv'
require 'smarter_csv'

# Uses smarter_csv gem to import and map data from CSV to the DB table directly.
namespace :import do
  desc 'Import movies and reviews from CSV files [using smarter_csv]'
  task movies_and_reviews: :environment do
    movies_data = SmarterCSV.process('assignment/movies.csv', key_mapping: { movie: :title })
    reviews_data = SmarterCSV.process('assignment/reviews.csv')

    Movie.create(movies_data)
    Review.create(reviews_data)
  end
end

namespace :import_data do
  desc 'Import movies and reviews from CSV files [using csv]'
  task movies_and_reviews: :environment do
    # Import movies
    movies_file_path = 'assignment/movies.csv'

    i = 0
    CSV.foreach(movies_file_path, headers: true) do |row|
      director = Director.find_or_create_by(name: row['Director'])
      country = Country.find_or_create_by(name: row['Country'])

      movie = Movie.find_or_create_by(title: row['Movie'],
                                      description: row['Description'],
                                      year: row['Year'],
                                      director:)
      actor = Actor.find_or_create_by(name: row['Actor'])
      location = FilmingLocation.find_or_create_by(location: row['Filming location'])

      movie.actors << actor unless movie.actors.find_by_id(actor.id)
      movie.countries << country unless movie.countries.find_by_id(country.id)
      movie.filming_locations << location unless movie.filming_locations.find_by_id(location.id)
    end

    # Import reviews
    reviews_file_path = 'assignment/reviews.csv'

    CSV.foreach(reviews_file_path, headers: true) do |row|
      movie = Movie.find_by(title: row['Movie'])
      next unless movie

      user = User.find_or_create_by(name: row['User'])
      Review.find_or_create_by(stars: row['Stars'], review: row['Review'], movie:, user:)
    end
  end
end

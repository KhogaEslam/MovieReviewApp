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


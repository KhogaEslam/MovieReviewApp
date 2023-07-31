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

    CSV.foreach(movies_file_path, headers: true) do |row|
      movie = Movie.find_by(title: 'Inception')
      actor = Actor.find_by(name: 'Leonardo Di Caprio')

      Movie.create(
        title: row['Movie'],
        description: row['Description'],
        year: row['Year'],
        director: row['Director'],
        actor: row['Actor'],
        filming_location: row['Filming location'],
        country: row['Country']
      )
    end

    # Import reviews
    reviews_file_path = 'assignment/reviews.csv'

    CSV.foreach(reviews_file_path, headers: true) do |row|
      Review.create(
        movie: row['Movie'],
        user: row['User'],
        stars: row['Stars'],
        review: row['Review']
      )
    end
  end
end
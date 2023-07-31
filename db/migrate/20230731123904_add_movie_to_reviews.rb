class AddMovieToReviews < ActiveRecord::Migration[7.0]
  def change
    add_reference :reviews, :movie, null: false, foreign_key: true
  end
end

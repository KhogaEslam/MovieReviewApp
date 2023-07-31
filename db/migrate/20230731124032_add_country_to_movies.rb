class AddCountryToMovies < ActiveRecord::Migration[7.0]
  def change
    add_reference :movies, :country, null: false, foreign_key: true
  end
end

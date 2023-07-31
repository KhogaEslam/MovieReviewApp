class CreateJoinTableMovieFilmingLocation < ActiveRecord::Migration[7.0]
  def change
    create_join_table :movies, :filming_locations do |t|
      t.index %i[movie_id filming_location_id], name: 'index_movie_location'
      t.index %i[filming_location_id movie_id], name: 'index_location_movie'
    end
  end
end

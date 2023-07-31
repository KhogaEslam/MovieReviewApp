class CreateJoinTableMovieCountries < ActiveRecord::Migration[7.0]
  def change
    create_join_table :movies, :countries do |t|
      t.index %i[movie_id country_id]
      t.index %i[country_id movie_id]
    end
  end
end

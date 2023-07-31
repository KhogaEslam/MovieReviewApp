class CreateJoinTableMovieActor < ActiveRecord::Migration[7.0]
  def change
    create_join_table :movies, :actors do |t|
      t.index %i[movie_id actor_id]
      t.index %i[actor_id movie_id]
    end
  end
end

class CreateFilmingLocations < ActiveRecord::Migration[7.0]
  def change
    create_table :filming_locations do |t|
      t.string :location

      t.timestamps
    end

    add_index :filming_locations, :location, unique: true
  end
end

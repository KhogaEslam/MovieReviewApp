class Movie < ApplicationRecord
  belongs_to :director

  has_and_belongs_to_many :countries
  has_and_belongs_to_many :actors
  has_and_belongs_to_many :filming_locations

  has_many :reviews
end

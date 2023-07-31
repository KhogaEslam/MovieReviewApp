class Movie < ApplicationRecord
  belongs_to :director

  has_and_belongs_to_many :countries
  has_and_belongs_to_many :actors
  has_and_belongs_to_many :filming_locations

  has_many :reviews

  scope :search, lambda { |text|
    left_joins(:actors)
      .where('actors.name LIKE :search', { search: "%#{text}%" })
  }
end

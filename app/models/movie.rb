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

  scope :sorted_by_reviews, lambda {
    left_joins(:reviews)
      .group(:id)
      .order(Arel.sql('AVG(reviews.stars) DESC NULLS LAST'))
  }

  def average_rating
    if reviews.exists?
      reviews.average(:stars).to_f
    else
      0.0
    end
  end

end

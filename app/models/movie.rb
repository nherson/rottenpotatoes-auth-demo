class Movie < ActiveRecord::Base
  attr_accessible :title, :rating, :description, :release_date, :director

  def self.all_ratings
    ['G', 'PG', 'PG-13', 'R']
  end

  def similar_movies
    Movie.find_all_by_director(self.director)
  end
end

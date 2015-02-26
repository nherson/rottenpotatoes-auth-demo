require 'spec_helper'

describe Movie do
  describe "#similar" do
    it "should find movies by the same director" do
      movie1 = Movie.create! :director => "Paul Newman"
      movie2 = Movie.create! :director => "Paul Newman"
      movie1.similar_movies.should include(movie2)
    end

    it "should not find movies by different directors" do
      movie1 = Movie.create! :director => "Paul Newman"
      movie2 = Movie.create! :director => "James Cameron"
      movie1.similar_movies.should_not include(movie2)
    end
  end
end

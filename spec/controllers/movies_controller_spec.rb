require 'spec_helper'

describe MoviesController do
  describe "#update" do
    before :each do
      @movie_id = "1234"
      @movie = double('fake movie').as_null_object
      Movie.stub(:find).with(@movie_id).and_return @movie
      @defaults = { :title => "Terrible Movie", :rating => "G", :directory => "Armando Fox" }
    end

    it "should update title" do
      @movie.should_receive(:update_attributes!).with hash_including 'title' => 'Awesome Movie'
      put :update, :id => @movie_id, :movie => @defaults.update(:title => 'Awesome Movie')
    end

    it "should update rating" do
      @movie.should_receive(:update_attributes!).with hash_including 'rating' => 'NC-17'
      put :update, :id => @movie_id, :movie => @defaults.update(:rating => 'NC-17')
    end

    it "should update director" do
      @movie.should_receive(:update_attributes!).with hash_including 'director' => 'David Patterson'
      put :update, :id => @movie_id, :movie => @defaults.update(:director => 'David Patterson')
    end
  end

  describe "#director" do
    context "When specified movie has a director" do
      it "should find movies with the same director" do
        @movie_id = "1234"
        @movie = double('fake movie', :director => 'James Cameron')
        Movie.should_receive(:find).with(@movie_id).and_return @movie
        Movie.should_receive(:find_all_by_director).with('James Cameron')
        get :director, :id => @movie_id
      end
    end

    context "When specified movie has no director" do
      it "should redirect to the movies page" do
        @movie_id = "1234"
        @movie = double('fake movie').as_null_object
        @movie.stub(:director).and_return(nil)
        Movie.should_receive(:find).with(@movie_id).and_return @movie
        get :director, :id => @movie_id
        response.should redirect_to(movies_path)
      end
    end
  end

  describe "#destroy" do
    it "should destroy specified movie" do
        @movie_id = "1234"
        @movie = double('fake movie').as_null_object
        Movie.stub(:find).with(@movie_id).and_return(@movie)
        @movie.should_receive(:destroy)
        delete :destroy, :id => @movie_id
    end
  end

  describe "#create" do
    it "should create movie with provided parameters" do
        @movie_id = "1234"
        @movie = double('fake movie').as_null_object
        Movie.should_receive(:create!).and_return(@movie)
        post :create, :movie => {}
    end
  end
end

class MoviesController < ApplicationController

  after_filter :verify_authorized, :except => [:index, :show, :director, :root]
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def root
    flash.keep
    redirect_to movies_path and return
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    session[:sort] = params[:sort] || session[:sort]
    ratings = params[:ratings].keys if params[:ratings].is_a?(Hash)
    session[:ratings] = ratings || session[:ratings] || @all_ratings
    if session[:sort] != params[:sort] or session[:ratings] != params[:ratings]
      flash.keep
      redirect_to movies_path(:sort => session[:sort], :ratings => session[:ratings])
    end
    @ratings = session[:ratings]
    @sort = {:order => session[:sort].to_sym} if session[:sort]
    @movies = Movie.find_all_by_rating(session[:ratings], @sort)
  end

  def new
    @movie = Movie.new    # Just a dummy so that we can use Pundit
    authorize @movie
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    authorize @movie
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
    authorize @movie
  end

  def update
    @movie = Movie.find params[:id]
    authorize @movie
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    authorize @movie
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  def director
    @movie = Movie.find(params[:id])
    @director = @movie.director
    if @director == "" or @director == nil
      flash[:warning] = "'#{@movie.title}' has no director info"
      redirect_to movies_path and return
    end
    @movies = Movie.find_all_by_director(@director)
  end

  def user_not_authorized
    flash[:alert] = "You must be an admin to do that!"
    redirect_to movies_path
  end

end

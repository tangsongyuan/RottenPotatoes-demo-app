class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index

    #@movies = Movie.all
        
    @all_ratings  = Movie.all_ratings
    @ratings = params[:ratings]

    @sort = params[:sort]
    @selected_ratings = @all_ratings
      
    redirect = 0
    
    if !(params[:sort].nil?)
      session[:sort] = params[:sort]
    elsif !(session[:sort].nil?)
      @sort = session[:sort]
      redirect = 1
    else
      @sort = nil
    end
    
    if !(@ratings.nil?)
      session[:ratings] = params[:ratings]
    elsif !(session[:ratings].nil?)
      @ratings = session[:ratings]
      redirect = 1
    else
      @ratings = nil
    end
    
    if redirect == 1
      flash.keep
      redirect_to movies_path :sort => @sort, :ratings => @ratings
    end
    
    if @ratings.nil? && @sort.nil?
      @movies = Movie.all
    elsif @ratings.nil? && !(@sort.nil?)
      @movies = Movie.order(@sort)
    elsif !(@ratings.nil?) && @sort.nil?
      @selected_ratings = @ratings.keys
      @movies = Movie.where(:rating => @ratings.keys)
    else
      @selected_ratings = @ratings.keys
      @movies = Movie.order(@sort).where(:rating => @ratings.keys)
    end
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end
  
  def hilite
    
  end

end

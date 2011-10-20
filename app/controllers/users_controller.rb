class UsersController < ApplicationController

  before_filter :authenticate, :except => [:show, :new, :create]
  before_filter :correct_user, :only   => [:edit, :update, :geigercounter]
  before_filter :admin_user,   :only   => :destroy

  def signup
    redirect_to :action => "new"
  end

  def new
    @user = User.new
    @title = "sign up"
  end

  def create 
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to Radioactive Map"
      redirect_to @user
    else 
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @user = User.find_by_username(params[:id])
    @title = "Edit your Profile"
  end

  def update
    p params[:id]
    @user = User.find_by_username(params[:id])
    p @user
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render "edit"
    end
  end

  def show
    @user = User.find_by_username(params[:id])
    if @user.nil?
      redirect_to "/home"
    else
      @followers = @user.followers.paginate(:page => 1)
      @following = @user.following.paginate(:page => 1)
      @measurements = @user.measurements.paginate(:page => params[:page])
    end
  end

  def index
    @users = User.paginate(:page => params[:page])
    @title = "All users"
  end

  def destroy
    User.find_by_username(params[:id]).destroy
    flash[:success] = "User destroyed"
    redirect_to users_path
  end

  def following
    @title = "Following"
    @user = User.find_by_username(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user = User.find_by_username(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
  end

  def geigercounter
    @title = "Geiger counter"
    @user = User.find_by_username(params[:id])
    @geigercounter = @user.geigercounter
    if @geigercounter.nil?
      @geigercounter = Geigercounter.new
      render "new_geiger"
    else
      render "show_geiger"
    end
  end

  private

    def correct_user
      @user = User.find_by_username(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end

end
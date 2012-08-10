class UsersController < ApplicationController
  before_filter :authenticate,    :only => [:index, :edit, :update]
  before_filter :authorize_user,  :only => [:edit, :update]


  def index
    #show all users
    @title = "All users"
    # @all_users = User.all #without WillPaginate functionality
    @users = User.paginate(:page => params[:page]) #with WillPaginate functionality
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
    
  def new
    @user  = User.new #initializes a raw User object
    @title = "Sign up"
  end
  
  def create
    # raise params[:user].inspect  #use this line to show the params data instead of submitting
    @user = User.new(params[:user]) #initialize a User object with the params retrieved from the POST request
    if @user.save 
      sign_in @user #this would not be required if an activation confirmation email is part of the sign up workflow
      redirect_to @user, # same as 'redirect_to user_path(@user)'
                  :flash => { :success => "Welcome to the Sample App!" }
    else
      @title = "Sign up"
      render 'new'      
    end
  end
  
  def edit
    @title = "Edit user"
    @user = User.find(params[:id])
  end
  
  def update
    #post to the User controller
    @title = "Edit user"
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
       redirect_to @user, # same as 'redirect_to user_path(@user)'
                    :flash => { :success => "Profile updated!" }
    else
      render 'edit'
    end
  end
  
  
  def destroy
    # @user = User.find(params[:id])
    # @user.destroy
  end
  
  
  private
  
    def authenticate
      deny_access unless signed_in?  #see sessions_helper.rb for deny_access method
    end
    
    def authorize_user
      #for user-specific actions; allow - otherwise redirect to root_path
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end

end

class UsersController < ApplicationController
  before_filter :authenticate,    :except => [:show, :new, :create]
  before_filter :authorize_user,  :only => [:edit, :update]
  before_filter :admin_user_only,      :only => :destroy


  def index
    #show all users
    @title = "All users"
    # @all_users = User.all #without WillPaginate functionality
    @users = User.paginate(:page => params[:page]) #with WillPaginate functionality
  end
  
  def show
    @user = User.find(params[:id])
    @title = @user.name
    @microposts = @user.microposts.paginate(:page => params[:page])
  end
  
  def following
    @title = "Following"
    @user = User.find(params[:id])
    @users = @user.following.paginate(:page => params[:page])
    render 'show_follow'
  end
  
  def followers
    @title = "Followers"
    @user = User.find(params[:id])
    @users = @user.followers.paginate(:page => params[:page])
    render 'show_follow'
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
    # @user = User.find(params[:id]) #assignment not needed since it was moved to the :authorize_user before_filter
  end
  
  def update
    #post to the User controller
    @title = "Edit user"
    # @user = User.find(params[:id]) #assignment not needed since it was moved to the :authorize_user before_filter
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
    # redirect_to(root_path) unless current_user.admin?
    
    user_to_delete = User.find(params[:id])
    
    if current_user?(user_to_delete)
      #prevent admin users from deleting themselves
      redirect_to users_path, :flash => { :error => "As an admin user, you may not delete your own account."}
    else
      user_to_delete.destroy 
      redirect_to users_path, :flash => { :success => "User has been deleted."}
    end
  end
  
  
  private
    
    def authorize_user
      #for user-specific actions; allow - otherwise redirect to root_path
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    
    def admin_user_only
      redirect_to(root_path) unless current_user.admin?
    end

end

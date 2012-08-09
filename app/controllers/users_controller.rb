class UsersController < ApplicationController


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
  
  def index
    #show all users
  end
  
  def destroy
    # @user = User.find(params[:id])
    # @user.destroy
  end
end

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
end

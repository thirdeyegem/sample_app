class UsersController < ApplicationController


  def show
    @user = User.find(params[:id])
    @title = @user.name
  end
    
  def new
    @user  = User.new #initializes a raw User object
    @title = "Sign up"
  end
end

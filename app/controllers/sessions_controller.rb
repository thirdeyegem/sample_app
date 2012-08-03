class SessionsController < ApplicationController
  #note: the include SessionsHelper is implemented at the Application level (see application_controller.rb)
  
  def new
    @title = "Sign in"
  end
  
  def create
    # raise params[:user].inspect  #use this line to show the params data instead of submitting
     user = User.authenticate(params[:session][:email],params[:session][:password])
     if !user.nil? 
       sign_in user
       redirect_to user, # same as 'redirect_to user_path(@user)'
                   :flash => { :success => "Welcome back #{user.name}!" }
     else
       @title = "Sign in"
       flash.now[:error] = "Invalid email/password combination."
       render 'new'      
     end
  end
  
  def destroy
  end
end

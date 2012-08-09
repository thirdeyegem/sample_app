module SessionsHelper
  
  def sign_in(user)
    #create a cookie on the client, with the content being a secure id token
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end
  
  def current_user=(user) #Rails setter method syntax "="
    @current_user = user #create a new instance of @current_user and assign the signed in user object
  end
  
  def current_user #getter method
    #return either an existing user session token or assign a new one by authenticating user with salt
    @current_user ||= user_from_remember_token
  end
  
  def signed_in?
    !current_user.nil? #returns true if user is signed in
  end
  
  def sign_out
    cookies.delete(:remember_token)
    current_user = nil  #if one gets RSpec errors running this statement; try prefixing  this call with 'self.' 
  end
  
  def current_user?(user)
    user == current_user
  end
    
  def deny_access
    store_requested_url
    redirect_to signin_path, :notice => "Sign in to proceed"  #:notice is the same as :flash => {:notice => ""}
  end  
  
  def store_requested_url
    session[:return_to] = request.fullpath #create a session-lasting cookie to store the path the user is trying to access
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil  #reset the return_to value in case there was one
  end
  
  private
  
    def user_from_remember_token
      User.authenticate_with_salt(*remember_token) # the * unwraps arrays into it's separate values
    end
    
    def remember_token
      #either return the cookie values, or two nils matching the number of params in the cookie
      cookies.signed[:remember_token] || [nil, nil]
    end
end

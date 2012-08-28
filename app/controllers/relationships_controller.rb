class RelationshipsController < ApplicationController
  before_filter :authenticate
  
  def create
    @user = User.find(params[:relationship][:followed_id]) #nested hash
    current_user.follow!(@user)
    respond_to do |format|  #response depends on format
      format.html { redirect_to @user } #response to http request
      format.js #response to AJAX request.  Note: this .js file needs to be created on a 'views' folder with the same name of the Model (i.e. views/relationships/create.js.erb)
    end
  end
  
  def destroy #without using AJAX
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|  #response depends on format
      format.html { redirect_to @user } #response to http request
      format.js #response to AJAX request.  Note: this .js file needs to be created on a 'views' folder with the same name of the Model (i.e. views/relationships/create.js.erb)
    end
  end
  
end
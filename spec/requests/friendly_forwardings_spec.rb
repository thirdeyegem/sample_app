require 'spec_helper'

describe "FriendlyForwardings" do
  
  it "should forward to the requested page after signin" do
    user = Factory(:user)
    visit edit_user_path(user)
    #sign in page should be rendered
    response.should have_selector('title', :content => "Sign in")
    #if so, then sign in a test user
    fill_in :email,     :with => user.email
    fill_in :password,  :with => user.password
    click_button
    #after signing in the user should be redirected to the original request of edit_user_path
    response.should render_template('users/edit')
    
    #the friendly forwarding should happen only the first time an unathenticated request is made
    #subsequent signin requests should not redirect automatically
    #in other words; the friendly forwarding cookie should be reset after every friendly forward instance
    visit signout_path
    visit signin_path
    fill_in :email,     :with => user.email
    fill_in :password,  :with => user.password
    click_button
    response.should render_template('users/show')
  end
  
end

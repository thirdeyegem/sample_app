# == Schema Information
#
# Table name: microposts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Micropost do

  before(:each) do
    @user = Factory(:user)
    @attr_invalid = {:content => "lorem ipsum", :user_id => @user}
    @attr = {:content => "lorem ipsum"}
  end
  
  
  it "should not create a new instance with invalid attributes" do
    lambda do
      Micropost.create!(@attr_invalid) #this method raises an exception because :user_id is not attr_accessible
      #Microposts should not be created and mutated (i.e. using '!' method), directly
      #instead they should be created through the associated model (i.e. @user.microposts.create!())
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  end
  
  
  it "should create a new instance with valid attributes" do
    @user.microposts.create!(@attr)
  end
  
  
  describe "user associations" do
    
    before(:each) do
      @micropost = @user.microposts.create(@attr)
    end
    
    it "should have a user attribute" do
      @micropost.should respond_to(:user)
    end
    
    it "should have the right associated user" do
      @micropost.user_id.should == @user.id
      @micropost.user.should == @user
    end
    
  end
  
  
  describe "Micropost validations" do
    
    it "should have an associated user" do
      Micropost.new(@attr).should_not be_valid
    end
    
    it "should require non-blank content" do
      @user.microposts.build(:content => "      ").should_not be_valid  #build is analog of .new
    end
    
    it "should reject content that is too long" do
      @user.microposts.build(:content => "a" * 141).should_not be_valid #see Micropost model for length validation
    end
  end


    describe "from_users_followed_by" do
      
      before(:each) do
        @other_user = Factory(:user, :email => Factory.next(:email))
        @third_user = Factory(:user, :email => Factory.next(:email))
        
        @user_post = @user.microposts.create!(:content => "foo")
        @other_post = @other_user.microposts.create!(:content => "bar")
        @third_post = @third_user.microposts.create!(:content => "baz")
        
        @user.follow!(@other_user)
      end
      
      it "should have from_users_followed_by method" do
        Micropost.should respond_to(:from_users_followed_by)
      end
      
      it "should include the followed user's micropost" do
        Micropost.from_users_followed_by(@user).
          should include(@other_post)
      end
      
      it "should include the current user's microposts" do
        Micropost.from_users_followed_by(@user).
          should include(@user_post)        
      end
      
      it "should not include an unfollowed user's microposts" do
        Micropost.from_users_followed_by(@user).
          should_not include(@third_post)
      end
    end
end

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

end

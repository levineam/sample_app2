require 'spec_helper'

describe Relationship do

  let(:follower) { FactoryGirl.create(:user) }
  let(:followed) { FactoryGirl.create(:user) }
  let(:relationship) { follower.relationships.build(followed_id: followed.id) }
  # note: in the User and MP tests we used @user and @micropost instead of
  #let because let is more a little advanced, but it's cleaner
  
  subject { relationship }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to follower_id" do
      expect do
        Relationship.new(follower_id: follower.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "follower methods" do    
    it { should respond_to(:follower) }
    it { should respond_to(:followed) }
    its(:follower) { should == follower }
    its(:followed) { should == followed }
  end
  #tests the user/relationships belongs_to association
  
  describe "when followed id is not present" do
    before { relationship.followed_id = nil }
    it { should_not be_valid }
  end

  describe "when follower id is not present" do
    before { relationship.follower_id = nil }
    it { should_not be_valid }
  end
  #testing the Relationship model validations
end

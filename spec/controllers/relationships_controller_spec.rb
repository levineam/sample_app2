require 'spec_helper'

describe RelationshipsController do

  let(:user) { FactoryGirl.create(:user) }
  let(:other_user) { FactoryGirl.create(:user) }

  before { sign_in user }

  describe "creating a relationship with Ajax" do

    it "should increment the Relationship count" do
      expect do
        xhr :post, :create, relationship: { followed_id: other_user.id }
      end.should change(Relationship, :count).by(1)
    end

    it "should respond with success" do
      xhr :post, :create, relationship: { followed_id: other_user.id }
      response.should be_success
    end
  end

  describe "destroying a relationship with Ajax" do

    before { user.follow!(other_user) }
    let(:relationship) { user.relationships.find_by_followed_id(other_user) }

    it "should decrement the Relationship count" do
      expect do
        xhr :delete, :destroy, id: relationship.id
      end.should change(Relationship, :count).by(-1)
    end

    it "should respond with success" do
      xhr :delete, :destroy, id: relationship.id
      response.should be_success
    end
  end
end
# This is the 1st example of a controller test, usually favors
#integration tests, but xhr method only works in controller test

# This uses the xhr method (for “XmlHttpRequest”) to issue an Ajax
#request; compare to the get, post, put, and delete methods used in
#previous tests. We then verify that the create and destroy actions do
#the correct things when hit with an Ajax request. (To write more
#thorough test suites for Ajax-heavy applications, take a look at
#Selenium and Watir.)
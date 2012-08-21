require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }
  #before do
    # This code is wrong! The problem is that by default (as of Rails
    #3.2.3) all of the attributes for our Micropost model are accessible,
    #this means that anyone could change any aspect of a micropost object
    #simply by using a command-line client to issue malicious requests
    #@micropost = Micropost.new(content: "Lorem ipsum", user_id: user.id)
  #end

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  #last two lines test micropost.user association
  
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      # verifies that calling Micropost.new w/a non-empty user_id raises
      #a mass assignment security error exception
    end
  end
  
  describe "when user_id is not present" do
    before { @micropost.user_id = nil }
    it { should_not be_valid }
  end
# Get these tests to pass by running:
#$ bundle exec rake db:migrate
#$ bundle exec rake db:test:prepare
  
  describe "with blank content" do
    before { @micropost.content = " " }
    it { should_not be_valid }
  end
  
  describe "with content that is too long" do
    before { @micropost.content = "a" * 141 }
    it { should_not be_valid }
  end
end


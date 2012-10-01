require 'spec_helper'

describe Charity do
  
  let(:user) { FactoryGirl.create(:user) }
  #before { @charity = user.charities.build(summary: "Lorem ipsum") }
  before { @charity = user.charities.build(FactoryGirl.attributes_for(:charity)) }
  # this makes sure that all the attributes for charity are set, whereas
  #the previous code only sets the "summary" attribute
  
  subject { @charity }
  
  it { should respond_to(:name) }
  it { should respond_to(:user_id) }
  it { should respond_to(:summary) }
  it { should respond_to(:description) }
  it { should respond_to(:user) }
  its(:user) { should == user }
  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Charity.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end
  
  describe "when user_id is not present" do
    before { @charity.user_id = nil }
    it { should_not be_valid }
  end
  
  describe "with blank name" do
    before { @charity.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @charity.name = "a" * 41 }
    it { should_not be_valid }
  end
  
  describe "name is already taken" do
    before do
      @charity.save
      @charity_with_same_name = @charity.dup
      @charity_with_same_name.name = @charity.name.upcase
      # the above line checks to make sure that changing the case makes
      #a duplicate name valid
      @charity_with_same_name.save
    end
    
    specify { @charity_with_same_name.should_not be_valid }
  end
  
  describe "with blank summary" do
    before { @charity.summary = " " }
    it { should_not be_valid }
  end
  
  describe "with summary that is too long" do
    before { @charity.summary = "a" * 141 }
    it { should_not be_valid }
  end
  
  describe "with blank description" do
    before { @charity.description = " " }
    it { should_not be_valid }
  end
end
 # verifies that calling Charity.new w/a nonempty user_id raises
    #mass assignment security error exception
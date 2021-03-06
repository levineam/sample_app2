# == Schema Information
#
# Table name: users
#
#  id         :integer         not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime        not null
#  updated_at :datetime        not null
#

require 'spec_helper'

describe User do

  # replaced w/below: before { @user = User.new(name: "Example User", email: "user@example.com") }
  before do
    @user = User.new(name: "Example User", email: "user@example.com", 
                     password: "foobar", password_confirmation: "foobar")
  end
  
  subject { @user } #allows us to leave out @user from below
  
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }
  it { should respond_to(:charities) }
  it { should respond_to(:feed) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }
  it { should respond_to(:unfollow!) }
  
  it { should be_valid }
  it { should_not be_admin }
  
  describe "accessible attributes" do
    it "should not allow access to admin" do
      expect do
        User.new(user_id: user.id)
          should raise_error(ActiveModel::MassAssignmentSecurity::Error)
      end
    end
  end
  # block for testing whether admin attrib is accessible
  
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end
    #uses the toggle! method to flip admin attribute from false to true
    #since when add the admin boolean attribute to users with:
    #rails generate migration add_admin_to_users admin:boolean, we then
    #add "default: false" to the column (by going to
    #[timestamp]_add_admin_to_users.rb), so toggling switches the value
    #to true, though if we hadn't set default as false, admin would
    #still have a value of nil, which is still false, but this conveys
    #what we're aiming for more explicitly to Rails and human readers
     
    #implies that the user should have an "admin?" boolean method
    # as usual add  admin attribute w/a migration indicating boolean
    #type in command line
    # $ rails generate migration add_admin_to_users admin:boolean
    # which simply adds the admin column to the users table
  
  describe "when password is not present" do
    before { @user.password = @user.password_confirmation = " " }
    it { should_not be_valid }
  end
  
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
    #case where passwords match is covered by "it { should respond_to(
    #:password_confirmation) }" we use this to test for a mismatch
  end
  
  describe "when password confirmation is nil" do
    before { @user.password_confirmation = nil }
    it { should_not be_valid }
  end
  
  describe "with a password that's too short" do
    before { @user.password = @user.password_confirmation = "a" * 5 }
    it { should be_invalid }
  end
  
  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by_email(@user.email) }
    
    describe "with valid password" do
      it { should == found_user.authenticate(@user.password) }
    end
    
    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }
      
      it { should_not == user_for_invalid_password }
      specify { user_for_invalid_password.should be_false }
    end
  end
  
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end
  
  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end
  
  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end
  
  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end
    
    it { should_not be_valid }
  end
  
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
    
    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end
  
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
    #is equivalent to it { @user.remember_token.should_not be_blank }
    #-->use "it" to apply test to the subject (e.g. "user") and "its"
    #to apply test to attribute of the subject (e.g. ":remember_token)
  end
  
  describe "micropost associations" do

    before { @user.save }
    let!(:older_micropost) do 
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      @user.microposts.should == [newer_micropost, older_micropost]
    end
    # last line is key, indicates posts should be ordered newest first,
    #and that user.microposts is an array of posts
    # get these to pass by use Rails facility default_scope and :order
    #parameter in micropost.rb
    # let variables are lazy, meaning that they only spring into
    #existence when referenced. The problem is that we want the
    #microposts to exist immediately, so that the timestamps are in the
    #right order and so that @user.microposts isn’t empty. We accomplish
    #this with let!, which forces the corresponding variable to come
    #into existence immediately.
    
    it "should destroy associated microposts" do
      microposts = @user.microposts
      @user.destroy
      microposts.each do |micropost|
        Micropost.find_by_id(micropost.id).should be_nil
      end
      # Micropost.find_by_id returns nil if the record is not
      #found, whereas Micropost.find raises an exception on failure,
      #which is a bit harder to test for
      # In case you’re curious:
#lambda do 
  #Micropost.find(micropost.id)
#end.should raise_error(ActiveRecord::RecordNotFound)
    end
    
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }
      
      before do
        @user.follow!(followed_user)
        3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
      its(:feed) do
        followed_user.microposts.each do |micropost|
          should include(micropost)
        end
      end
    end
    # uses the array include? method, which simply checks if an array
    #includes the given element
    # :feed is defined in user.rb
  end
  
  describe "charity associations" do

    before { @user.save }
    let!(:older_charity) do 
      FactoryGirl.create(:charity, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_charity) do
      FactoryGirl.create(:charity, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right charities in the right order" do
      @user.charities.should == [newer_charity, older_charity]
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }    
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }
  # first part of test creates a user "other_user) and has @user follow
  #it. The second part makes sure the @user is following other_user and
  #that other_user is stored in @user's followed_users column
  # following? and following! defined in user.rb
  
    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
    # Notice how we switch subjects using the subject method, replacing
    #@user with other_user, allowing us to test the follower
    #relationship in a natural way
  
    describe "and unfollowing" do
      before { @user.unfollow!(other_user) }

      it { should_not be_following(other_user) }
      its(:followed_users) { should_not include(other_user) }
    end
    #see user.rb for definition of unfollow!(other_user)
  end
end

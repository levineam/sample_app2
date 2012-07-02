require 'spec_helper'

describe "Authentication" do
  
  subject { page }
  
  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }
  end
  
  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end
    
    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.name) }

      it { should have_link('Users',    href: users_path) }
      it { should have_link('Profile',  href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }

      it { should_not have_link('Sign in', href: signin_path) }
      
      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end
      #uses a helper located in spec/support/utilities.rb to sign in
      #a user inside tests
    end
  end
  
  describe "authorization" do
    
    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
        
      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          #visit the user edit page
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end
        
        describe "after signing in" do
          
          it "should render the desired protected page" do
            page.should have_selector('title', text: 'Edit user')
            #should be directed to user's own edit page
          end
        end
      end
    # to test friendly forwarding (when a user tries to access another
    #user's edit page, we redirect them to their own edit page instead
    
    #we first visit the user edit page, which redirects to the signin
    #page. We then enter valid signin information and click the
    #“Sign in” button. The resulting page, which by default is the
    #user’s profile, should in this case be the “Edit user” page. 
      
      describe "in the Users controller" do
        
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text: 'Sign in') }
        end
        
        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end
        #an alternate way to capybara's "visit" method to access a
        #controller action, by issuing the appropriate HTTP request,
        #here the "put" method to issue a PUT request. This issues a
        #PUT request directly to /users/1, which gets routed to the
        #"update" action of the Users controller-->necessary because
        #no way for a browser to visit update action directly
        
        #using methods to issue HTTP requests directly gives access to
        #low-level response object, which lets us test the server
        #response itself, here verifying the "update" action responds
        #by redirecting to the signin page
        
        describe "visit the user index" do
          before { visit users_path }
          it { should have_selector('title', text: 'Sign in') }
        end
        #note this is the "users_path", plural, not the user_path
      end
      
      describe "as wrong user" do
        let(:user) { FactoryGirl.create(:user) }
        let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
        #note that a factory (here ":user") can take an option ("email:
        #"wrong@example.com"), so the line above creates a user ("wrong_
        #user) then uses FactoryGirl to make it a ":user" with an email,
        #wrong@example.com, which is different than the default
        before { sign_in user }
        
        describe "visiting Users#edit page" do
          before { visit edit_user_path(wrong_user) }
          it { should_not have_selector('title',
                                      text: full_title('Edit user')) }
        end
        #testing that when wrong_user visits the edit page, there
        #should be no "Edit user" option
        
        describe "submitting a PUT request to the Users#update action" do
          before { put user_path(wrong_user) }
          #remember, this PUT request is issued directly to /users/1,
          #which gets routed to the update action of the Users controller
          specify { response.should redirect_to(root_path) }
        end
        #testing that when wrong_user submits a put request for the
        #user's update action, they are redirected to the root_path
        #which is their profile 
        
        #the application has two before_filters in the users_controller
        #to protect the edit and update actions
      end
    end
  end
end
  

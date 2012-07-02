class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :edit, :update]
  #before_filter arranges for a particular method to be called before
  #the given actions, here: signed_in_user method, which must define
  
  #by default applies to all actions in controller, so restrict to
  #:edit and :update actions
  before_filter :correct_user,   only: [:edit, :update]
  #correct_user uses the current_user? boolean method which we define
  #in the sessions_helper to make sure not just that the user trying
  #to edit and update is signed in, but that they are the correct user
  #who should have access to those actions
  
  #both signed_in_user and correct_user are defined below under private
  
  def index
    @users = User.all
  end
  # the application code uses User.all to pull all the users out of the
  #database, assigning them to an @users instance variable for use in
  #the view, but showing all the users at once is bad, so must fix
  
  
  def show
    @user = User.find(params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save
      # Handles a succesful save. The "validates" methods in user.rb
      #ensures that only if a name, email, pw and pw confirmation are
      #provided will a user be able to be saved
      sign_in @user
      # sign_in method was created in section 8.2.2, it's defined in the
      # sessions_helper module
      flash[:success] = "Welcome to CharHub!"
      #line above works with flash code in application.html.erb to flash
      #a welcome message if the user succesfully signs up
      redirect_to@user
      #the above line redirects the user to their profile page after
      #they have succesfully signed up to the site, without this line
      #rails would try to render view corresponding to the "create" action
      #which there, should not be, we just want the data saved
    else
      render 'new'
      #renders a new signup page if invalid or insufficient information
      #was provided?
    end
  end
  
  def edit
    #@user = User.find(params[:id] ) --> not needed once the
    #correct_user before filter defines @user, same goes for def update
  end
  
  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      #update_attributes updates the user based on the submitted params
      #hash, w/invalid info, the update attempt returns false, so the
      #else branch re-renders the edit page
      flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
    #in plain english: if the submitted info (which is inside the
    #params hash) is valid, then update the user's info/attributes, if
    #not, then re-render the edit page
  end
  
  private
  
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_path, notice: "Please sign in" #unless signed_in?
      end
    end
    #"notice: "Please sign in." 
    #is a shortcut for:
    #flash[:notice] "Please sign in."
    #redirect_to signin_path, same construction works for :error key,
    #but not :success
    
    #:success, :error and :notice are the three flash styles supported
    #natively by Bootstrap CSS
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_path) unless current_user?(@user)
    end
    #uses the current_user? boolean method, defined in the sessions
    #helper to make sure that in order to be a "correct_user" one must
    #also be the "current_user." current_user is another method we
    #defined in the sessions_helper which associates the remember token
    #with the user
end

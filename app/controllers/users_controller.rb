class UsersController < ApplicationController
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
end


class SessionsController < ApplicationController
  
  def new
  end
  
  def create
    user = User.find_by_email(params[:session][:email])
    if user && user.authenticate(params[:session][:password])
      #Sign the user in and redirect to the user's show page
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination' # Not quite right!
        #unlike "flash", "flash.now" is designed for flashing messages
        #on rendered pages, its contents disappear as soon as there is
        #an additional request
      render 'new'
        #renders "new.html.erb", a new signin page
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
end

class MicropostsController < ApplicationController
  before_filter :signed_in_user, only: [:create, :destroy]
  before_filter :correct_user,   only: [:destroy]

# if don't restrict the actions the before filter applies to,
#it applies to all the actions below it by default. But if you wanted
#to add an action (e.g an index) that was accessible to non-signed in
#users as well, you'd have to make it:
#before_filter :signed_in_user, only: [:create, :destroy]

  def create
    @micropost = current_user.microposts.build(params[:micropost])
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url
  end
  
  private
  
    def correct_user
      @micropost = current_user.microposts.find_by_id(params[:id])
      redirect_to root_url if @micropost.nil?
    end
    # ensures that we find only mps belonging to the current user
    # we use find_by_id because it returns nil, whereas "find" returns
    #an exception
end

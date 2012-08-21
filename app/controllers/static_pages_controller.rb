class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.microposts.build #if signed_in?
      #advantage: this will break test sweet if user not signed in
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
end

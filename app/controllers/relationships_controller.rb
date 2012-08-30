class RelationshipsController < ApplicationController
  before_filter :signed_in_user

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    respond_to do |format|
      format.html { redirect_to @user }
      format.js
    end
  end
end
# note, as we can see here, even if an unsigned-in user were to hit either
#action directly (e.g by using a command-line tool), current_user would
#be nil, and in both cases the action's second line would raise an exception,
#causing an error, but no harm to the app or its data

# uses respond_to to take the appropriate action depending on the kind of
#request. There is no relationship between this respond_to and the
#respond_to used in the RSpec examples. Important to understand that only
#ONE line gets executed based on the nature of the request, i.e. Ajax or
#html

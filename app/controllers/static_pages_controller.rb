class StaticPagesController < ApplicationController
  def home
    #an empty micropost for the form to post new post
    @micropost = current_user.microposts.build if logged_in?
    # lists of posts by the current user
    @feed_items = Micropost.feed(current_user.id).paginate(page: params[:page])
  end

  def help
  end

  def about
  end

  def contact
  end
end

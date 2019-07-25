class RelationshipsController < ApplicationController
    before_action :logged_in_user
    # POST /relationships
    def create
        user = User.find_by(id: params[:followed_id])
        current_user.follow(user)
        redirect_to user_url(user)
    end
    # DELETE /relationships/1
    def destroy
        user = Relationship.find_by(id: params[:id]).followed
        current_user.unfollow(user)
        redirect_to user_url(user)
    end
end

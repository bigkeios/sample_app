class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :update]

    # POST /microposts
    def create
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
            flash[:success] = "New micropost created"
            redirect_to root_path
        else
            # @feed_items = []
            render 'static_pages/home'
        end
    end
    # PATCH /microposts/1
    def update
    end

    private
    def micropost_params
        params.require(:micropost).permit(:content)
    end
end

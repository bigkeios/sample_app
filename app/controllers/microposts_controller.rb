class MicropostsController < ApplicationController
    before_action :logged_in_user, only: [:create, :update, :destroy]
    before_action :correct_user, only: [:destroy]

    # POST /microposts
    def create
        @micropost = current_user.microposts.build(micropost_params)
        if @micropost.save
            flash[:success] = "New micropost created"
            redirect_to root_path
        else
            @feed_items = Micropost.feed(current_user.id).paginate(page: params[:page])
            render 'static_pages/home'
        end
    end
    # PATCH /microposts/1
    def update
    end

    # DELETE /microposts/1
    def destroy
        @micropost.destroy
        flash[:success] = "Micropost deleted"
        redirect_to request.referrer || root_url
    end
    private
    def micropost_params
        params.require(:micropost).permit(:content, :picture)
    end
    
    def correct_user
        @micropost = current_user.microposts.find_by(id: params[:id])
        redirect_to root_url if @micropost.nil?
    end
end

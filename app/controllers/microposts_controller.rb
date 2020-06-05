class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:seccess] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end
  
  def destroy
  end

  private
  
    def micropost_params
      # micropost属性必須 content属性のみ変更を許可
      params.require(:micropost).permit(:content)
    end
end

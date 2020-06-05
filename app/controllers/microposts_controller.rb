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
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  private
  
    def micropost_params
      # micropost属性必須 content属性のみ変更を許可
      params.require(:micropost).permit(:content)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: patams[:id])
      redirect_to root_url if @micropost.nil?
    end
end

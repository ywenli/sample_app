class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user, only: :destroy
  
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
    # リダイレクト (request.referrer で返される)1つ前のurl またはroot_url
    request.referrer || root_url
    # redirec_backで直前に実行したアクションへリダイレクト
    # 引数のfallback_locationオプションで例外が発生したときroot_urlにリダイレクト
    # redirect_back(fallback_location: root_url)
  end

  private
  
    def micropost_params
      # micropost属性必須 content, picture属性のみ変更を許可
      params.require(:micropost).permit(:content, :picture)
    end
    
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end

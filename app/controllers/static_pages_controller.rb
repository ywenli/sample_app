class StaticPagesController < ApplicationController
  
  def home
    if logged_in?
      # @micropostに代入 現在のユーザーに紐づいたMicropostオブジェクトを返す
      # ユーザーがログインしていれば
      @micropost = current_user.microposts.build
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

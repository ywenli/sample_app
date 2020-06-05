class StaticPagesController < ApplicationController
  
  def home
    # @micropostに代入 現在のユーザーに紐づいたMicropostオブジェクトを返す
    # ユーザーがログインしていれば
    @micropost = current_user.microposts.build if logged_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
end

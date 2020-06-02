class UsersController < ApplicationController
  # 直前にlogged_in_userメソッドを実行　edit, updateにのみ適用
  before_action :logged_in_user, only: [:edit, :update]
  
  def show
    # User.find(1) と同じ
    @user = User.find(params[:id]) 
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Sample app!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    # 指定された属性の検証が全て成功した場合@userの更新と保存を続けて同時に行う
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # 更新失敗時はeditアクションに対応したviewが返る
      render 'edit'
    end
  end

  private
  
    def user_params
       params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # before アクション
    
    # ログイン済ユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
end

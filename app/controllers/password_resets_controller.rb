class PasswordResetsController < ApplicationController
  # フィルタの内容は下部private以下
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  
  def new
  end
  
  def create
    # (フォームに入力された) email（を小文字にしたやつ）を持ったuserをDBから見つける
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      # @userのパスワード再設定の属性を設定する(crate_reset_digestはapp/models/user.rbにある)
      @user.create_reset_digest
      # @userにパスワード再設定メールを送る(send_password_reset_emailはapp_odels/user.rbにある)
      @user.send_password_reset_email
      flash[:info] = "Email sent with password reset instructions"
      redirect_to root_url
    else
      flash.now[:danger] = "Email address not found"
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    if params[:user][:password].empty? 
      @user.errors.add(:password, :blank)
      render 'edit'
    elsif @user.update_attributes(user_params)
      log_in @user
      # :reset_digestの値をnil = パスワード再設定が成功され、値が削除
      @user.update_attribute(:reset_digest, nil)
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'
    end
  end
    
  private
    # :userが必須 パスワードとパスワード確認の属性のみ許可
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    # boeforeフィルタ
    
    def get_user
      @user = User.find_by(email: params[:email])
    end
    
    # 正しいユーザーかどうか確認する
    def valid_user
      # 条件がfalseの場合
      unless (@user && @user.activated? && @user.authenticated?(:reset, params[:id]))
        redirect_to root_url
      end
    end
    
    # トークンが期限切れかどうか確認する
    def check_expiration
      if @user.password_reset_expired?
        flash[:danger] = "Password reset has been expired."
        redirect_to new_password_reset_url
      end
    end
end

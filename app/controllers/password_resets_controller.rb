class PasswordResetsController < ApplicationController
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
end

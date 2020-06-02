class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    if @user && @user.authenticate(params[:session][:password])
      # log_in メソッド session[:user_id] にuser.id を代入
      log_in @user
      params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
      # SessionsHelperで定義したredirect_back_orメソッドを呼び出してリダイレクト先を定義
      redirect_back_or @user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end


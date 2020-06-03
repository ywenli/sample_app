class AccountActivationsController < ApplicationController

  def edit
    user = User.find_by(email: params[:email])
    # userが存在する && userがactivatedではない && 有効化トークンとparams[:id](activation_token)がもつ有効化ダイジェストが一致した場合
    if user && !user.activated? && user.authenticated?(:activation, params[:id])
      user.update_attribute(:activated, true)
      user.update_attribute(:activated_at, Time.zone.now)
      log_in user
      flash[:success] = "Account activated!"
      redirect_to user
    else
      flash[:danger] = "Invalid activation link"
      redirect_to root_url
    end
  end
end
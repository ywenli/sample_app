class UsersController < ApplicationController
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
      # 更新に成功した場合を扱う
    else
      # 更新失敗時はeditアクションに対応したviewが返る
      render 'edit'
    end
  end

  private
  
    def user_params
       params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end

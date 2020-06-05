class UsersController < ApplicationController
  # 直前にlogged_in_userメソッドを実行　edit, updateにのみ適用
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  
  def index
    # params[:page] はwill_paginateによって自動的に生成される
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def show
    # User.find(1) と同じ
    @user = User.find(params[:id])
    # @micropostsに @userのmicropostsのページネーションの指定ページ(params[:page]) を代入
    @microposts = @user.microposts.paginate(page: params[:page])
    # trueの場合、ここで処理が終了
    # @userが有効ではない場合、リダイレクトは実行されない
    redirect_to root_url and return unless @user.activated?
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
      # Userモデルで定義したメソッド(send_activation_email)を呼び出して有効化メールを送信
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'new'
    end
  end
  
  def edit
  end
  
  def update
    # 指定された属性の検証が全て成功した場合@userの更新と保存を続けて同時に行う
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      # 更新失敗時はeditアクションに対応したviewが返る
      render 'edit'
    end
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  # 外部に公開されないメソッド 
  private
    # 許可された属性リストにadminが含まれいない = admin は編集できない
    def user_params
       params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
    
    # before アクション
    
    # ログイン済ユーザーかどうか確認
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
      
    # 正しいユーザーかどうか確認
    def correct_user
      @user = User.find(params[:id])
      # root_url にリダイレクト　以下の式がfalse の場合　@user とcurrent_userが等しい
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # 管理者かどうか確認
    def admin_user
      # current_user.admin? ログイン中のユーザーが管理者でない場合
      redirect_to(root_url) unless current_user.admin?
    end
end

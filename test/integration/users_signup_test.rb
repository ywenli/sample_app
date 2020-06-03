require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  
  def setup
    # deliveries変数に配列として格納されたメールをクリア
    ActionMailer::Base.deliveries.clear
  end
  
  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name: "",
      email: "user@invalid",
      password: "foo",
      password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    #id = "error_explanation"を持つdivがある
    #assert_select 'div#<CSS id for error explanation>'
    #class = "alert-dange"を持つdivがある
    #assert_select 'div.<CSS class for field with error>'
    assert_select 'form[action="/signup"]'
  end
  
  test "valid signup information with account activation" do
    get signup_path
    assert_difference "User.count", 1 do
      post users_path, params: { user: {name: "Example User",
      email: "user@example.com",
      password: "password",
      password_confirmation: "password"} }
    end
    # 引数の値が等しい 1とActionMailer::Base.deliveriesに格納された配列の数
    # 配信されたメッセージがきっかり1つであるかどうかを確認
    assert_equal 1, ActionMailer::Base.deliveries.size
    # userに@userを代入(通常統合テストからはアクセスできないattr_accessorで定義して属性の値にもアクセスできるようになる)
    user = assigns(:user)
    assert_not user.activated?
    # 有効化してない状態でログインしてみる
    log_in_as(user)
    assert_not is_logged_in?
    # 有効化トークンが不正な場合
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # トークンは正しいがメールアドレスが無効な場合
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # 有効化トークンが正しい場合
    get edit_account_activation_path(user.activation_token, email: user.email)
    # userの値を再取得すると有効化されている
    assert user.reload.activated?
    # 実際にリダイレクト先に移動
    follow_redirect!
    assert_template 'users/show'
    # テストユーザーがログインしている
    assert is_logged_in?
    
  end
end

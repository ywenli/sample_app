require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {name: "",
      email: "foo@invalid",
      password: "foo",
      password_confirmation: "bar" } }
    
    assert_template 'users/edit'
    # 特定のHTMLタグが存在する
    # class="alert"のdiv, 4個のエラーがある
    assert_select "div.alert", "The form contains 4 errors."
  end
end

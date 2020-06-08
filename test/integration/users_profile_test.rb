require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  # ApplicationHelperの読み込み = full_titleヘルパーが使える
  include ApplicationHelper
  
  def setup
    @user = users(:michael)
  end
  
  test "profile display" do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    # h1のタグに含まれるimg.gravatar
    assert_select 'h1>img.gravatar'
    # @userのマイクロポストのcountを文字列にしたもの
    assert_match @user.microposts.count.to_s, response.body
    # class = "pagination"を持つdivタグが1こ
    assert_select 'div.pagination', count: 1
    # @user.micropostsのページネーションの1ページ目の配列を1個ずつ取り出してmicropostに代入
    @user.microposts.paginate(page: 1).each do |micropost|
      assert_match micropost.content, response.body
    end
    # ユーザーの能動的関係 = フォローしている数
    assert_match @user.active_relationships.count.to_s, response.body
    # ユーザーの受動的関係 = フォローされている
    assert_match @user.passive_relationships.count.to_s, response.body
  end
end

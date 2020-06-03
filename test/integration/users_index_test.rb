require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @non_activated = users(:non_activated)
  end
  
  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    # users(:non_activated)が存在しないことを確認
    assert_select 'a[href=?]', user_path(@non_activated), text: @non_activated.name, count: 0
    # 特定のhtmlタグが存在する div class="pagination" 2つ
    assert_select 'div.pagination', count: 2
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      # 特定のhtml タグが存在する a href
      # パスはuser_path(user), 表示テキストはuser.name
      assert_select'a[href=?]', user_path(user), text: user.name
      # (eachで取り出された)user == @admin がfalseの場合
      unless user == @admin
        # 表示テキストは'delete' 管理ユーザー以外に削除の表示がある状態
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
    # user_path(@non_activated)にgetリクエスト
    get user_path(@non_activated)
    assert_redirected_to root_path
  end
  
  test "index as non-admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
  
end

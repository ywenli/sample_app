require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:michael)
  end
  
  test "index including pagination" do
    log_in_as(@user)
    get users_path
    assert_template 'users/index'
    # 特定のhtmlタグが存在する div class="pagination" 2つ
    assert_select 'div.pagination', count: 2
    # 特定のhtmlタグが存在する div class="pagination"
    assert_select 'div.pagination'
    User.paginate(page: 1).each do |user|
      # 特定のhtml タグが存在する a href
      # パスはuser_path(user), 表示テキストはuser.name
      assert_select'a[href=?]', user_path(user), text: user.name
    end
  end
  
end

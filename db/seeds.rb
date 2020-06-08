# ユーザー
# テーブル名.create! カラムと持たせたい値
User.create!(name: "Example User",
  email: "example@railstutorial.org",
  password: "foobar",
  password_confirmation: "foobar",
  # 管理者にする
  admin: true,
  # ユーザーが有効化されている
  activated: true,
  # 有効になった日時: サーバーのタイムゾーンに応じたタイムスタンプを返す
  activated_at: Time.zone.now)

# 99回繰り返す(timesメソッド)
99.times do |n|
  name = Faker::Name.name
  # emailに代入 example-#{n+1}@railstutorial.org
  # それぞれのアドレスが変わるように指定
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name,
    email: email,
    password: password,
    password_confirmation: password,
    activated: true,
    activated_at: Time.zone.now)
end

# マイクロポスト
users = User.order(:created_at).take(6)
50.times do
  # Faker::Loremか文章を5個取り出して代入
  content = Faker::Lorem.sentence(5)
  # usersを順番に取り出してブロック内を実行
  # 取り出した要素をuserに代入　userに紐づいたmaicropostを作成
  users.each { |user| user.microposts.create!(content: content) }
end

# リレーションシップ
users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
# 最初のユーザーにユーザー3からユーザー51までをフォローさせる
following.each { |followed| user.follow(followed) }
# ユーザー4からユーザー41に最初のユーザーをフォローさせる
followers.each { |follower| follower.follow(user) }

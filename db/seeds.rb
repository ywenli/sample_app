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
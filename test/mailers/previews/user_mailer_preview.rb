# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/account_activation
  def account_activation
    user = User.first
    # userのactivation_tokenに有効化トークンを代入
    user.activation_token = User.new_token
    # UserMailerクラスのaccount_activationメソッドを呼び出し（引数にuserを渡す）
    UserMailer.account_activation(user)
  end

  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/password_reset
  def password_reset
    UserMailer.password_reset
  end

end

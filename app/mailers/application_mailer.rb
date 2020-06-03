class ApplicationMailer < ActionMailer::Base
  # 送信元アドレスはアプリケーション全体で
  default from: 'noreply@example.com'
  layout 'mailer'
end

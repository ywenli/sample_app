class User < ApplicationRecord
  before_save { email.downcase! } # メソッドの末尾に! を足してemail属性を直接変更
  validates :name, presence: true, length: { maximum: 50 }
  # validates(:name, presence: true) と同じ
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence: true, length: { maximum: 255 }, 
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
end

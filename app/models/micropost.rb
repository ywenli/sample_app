class Micropost < ApplicationRecord
  # 自動生成
  # MicropostとそのUserは belongs_to(1対1)の関係
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  # user_idが存在する
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  
end

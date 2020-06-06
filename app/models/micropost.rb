class Micropost < ApplicationRecord
  # 自動生成
  # MicropostとそのUserは belongs_to(1対1)の関係
  belongs_to :user
  # Micropostモデルに画像を追加する
  mount_uploader :picture, PictureUploader
  default_scope -> { order(created_at: :desc) }
  # user_idが存在する
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }
  # シンボル名:picturesize に対応したメソッドを呼び出す
  validate :picture_size
  
  private
  
  # アップロードされた画像のサイズをバリデーションする
  def picture_size
    # 5MBを超えた場合は
    if picture.size > 5.megabytes
      # カスタムのエラーメッセージをerrorsコレクションに追加
      errors.add(:picture, "should be less than 5MB")
    end
  end
end

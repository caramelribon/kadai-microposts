class Micropost < ApplicationRecord
  belongs_to :user
  
  # micropost側からfavoriteに参照
  has_many :favorites
  
  validates :content, presence: true, length: { maximum: 255 }
end

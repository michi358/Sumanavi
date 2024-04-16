class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
  has_many :post_comments, dependent: :destroy
  belongs_to :genre
  has_many :favorites, dependent: :destroy
  
  validates :title, presence: true
  validates :content, presence: true
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
end

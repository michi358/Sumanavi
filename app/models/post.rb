class Post < ApplicationRecord
  belongs_to :user
  has_rich_text :content
 
  has_many :post_comments, dependent: :destroy
  belongs_to :genre
  
  validates :title, presence: true
  validates :content, presence: true
end

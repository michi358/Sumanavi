class Tag < ApplicationRecord
  has_many :post_tags, dependent: :destroy
  has_many :posts, through: :post_tags
  
  validates :name, presence:true, length:{maximum:50}
  
  # 検索方法分岐
  def self.search_for(content, method)
    if method == 'perfect'
      Tag.where(name: content)
    elsif method == 'forward'
      Tag.where('name LIKE ?', content + '%')
    elsif method == 'backward'
      Tag.where('name LIKE ?', '%' + content)
    else
      Tag.where('name LIKE ?', '%' + content + '%')
    end  
  end
end

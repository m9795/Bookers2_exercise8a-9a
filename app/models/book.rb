class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  # has_many :favorited_user, through: :favorites, source: :user
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end
  
  def self.favorite_ranks
    Book.find(Favorite.group(:book_id).order('count(book_id) desc').pluck(:book_id))
  end
  # 作成日時の降順で表示される
  # default_scope -> { order(created_at: :desc) }
  
  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}
  
  def self.looks(search, word)
    if search == "perfect_match"
      @book = Book.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @book = Book.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @book = Book.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @book = Book.where("title LIKE?","%#{word}%")
    else
      @book = Book.all
    end
  end
  
end

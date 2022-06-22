class Book < ApplicationRecord
  belongs_to :user
  has_many :book_comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.favorites_rank
    #先週にするとデータ表示されなかったため、いったん今日を含む今週ランキングで表示するためコメントアウト
    # Book.joins(:favorites).where(favorites: { created_at: 0.days.ago.prev_week..0.days.ago.prev_week(:sunday)}).group(:book_id).order("count(book_id) desc")
    #今週のランキング表示 0いいねが表示されない↓
    Book.find(Favorite.group(:book_id).where(created_at: Time.current.all_week).order('count(book_id) desc').pluck(:book_id))
  end

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

class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } 
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } 

  scope :created_days_ago, -> (n) { where(created_at: n.days.ago.all_day) }
  
  # 投稿数が０の時のエラー回避
  def self.count_even_zero
   blank? ? 0 : count
  end
  
  def self.count_week_book
    (1..6).map { |n| created_days_ago(n).count }.reverse
  end
  
  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.looks(search, word)

    if search == 'perfect_match'
      Book.where(title: word)
    elsif search == 'forward_match'
      Book.where('title LIKE ? OR body LIKE ?', "#{word}%", "#{word}%")
    elsif search == 'backward_match'
      Book.where('title LIKE ? OR body LIKE ?', "%#{word}", "%#{word}")
    else
      Book.where('title LIKE ? OR body LIKE ?', "%#{word}%", "%#{word}%")
    end
  end
end
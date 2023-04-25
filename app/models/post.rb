class Post < ApplicationRecord
  has_one_attached :image
  belongs_to      :user
  has_many :post_tags,dependent: :destroy
  has_many :tags, through: :post_tags ,dependent: :destroy

  has_many        :favorites,    dependent: :destroy
  has_many        :post_comments, dependent: :destroy

  validates :title, presence: true
  validates :body, presence:true

  #scope :スコープの名前, -> {条件式}
  scope :created_today, ->  { where(created_at: Time.zone.now.all_day) } #今日
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) } #昨日
  scope :created_2days_ago, -> { where(created_at: 2.days.ago.all_day) }
  scope :created_3days_ago, -> { where(created_at: 3.days.ago.all_day) }
  scope :created_4days_ago, -> { where(created_at: 4.days.ago.all_day) }
  scope :created_5days_ago, -> { where(created_at: 5.days.ago.all_day) }
  scope :created_6days_ago, -> { where(created_at: 6.days.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) } #今週
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) } #先週


  def   favorited_by?(user)
       favorites.exists?(user_id: user.id)
  end
  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @post = Post.where("title LIKE?","#{word}")
    elsif search == "forward_match"
      @post = Post.where("title LIKE?","#{word}%")
    elsif search == "backward_match"
      @post = Post.where("title LIKE?","%#{word}")
    elsif search == "partial_match"
      @post = Post.where("title LIKE?","%#{word}%")
    else
      @post = Post.all

    end
  end

  def save_tag(sent_tags)
  # タグが存在していれば、タグの名前を配列として全て取得
    current_tags = self.tags.pluck(:name) unless self.tags.nil?
    # 現在取得したタグから送られてきたタグを除いてoldtagとする
    old_tags = current_tags - sent_tags
    # 送信されてきたタグから現在存在するタグを除いたタグをnewとする
    new_tags = sent_tags - current_tags

    # 古いタグを消す
    old_tags.each do |old|
      self.tags.delete Tag.find_by(name: old)
    end

    # 新しいタグを保存
    new_tags.each do |new|
      new_post_tag = Tag.find_or_create_by(name: new)
      self.tags << new_post_tag
   end
  end

   def get_image
    (image.attached?) ? image : 'no_image.jpg'
   end

end

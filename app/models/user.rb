class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise          :database_authenticatable, :registerable,
                 :recoverable,             :rememberable, :validatable

  has_many        :posts,        dependent: :destroy
  has_many        :favorites,    dependent: :destroy
  has_many        :post_comments,dependent: :destroy

  has_one_attached :profile_image

  validates       :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates       :introduction, length: {maximum: 50}


  # 検索方法分岐
  def self.looks(search, word)
    if search == "perfect_match"
      @user = User.where("name LIKE?", "#{word}")
    elsif search == "forward_match"
      @user = User.where("name LIKE?","#{word}%")
    elsif search == "backward_match"
      @user = User.where("name LIKE?","%#{word}")
    elsif search == "partial_match"
      @user = User.where("name LIKE?","%#{word}%")
    else
      @user = User.all
    end
  end

   # is_deletedがfalseならtrueを返すようにしている 退会機能
  def active_for_authentication?
    super && (is_deleted == false)
  end


  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end
end

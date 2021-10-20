class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  attachment :profile_image, destroy: false
  has_many :books
  has_many :favorites
  has_many :book_comments
  validates :name, presence: true, length: {maximum: 10, minimum: 2}
  validates :introduction, length: {maximum: 50}

  # フォロワー
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'followee_id', dependent: :destroy
  has_many :followers,through: :reverse_of_relationships, source: :follower

  # フォローしている人
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id"
  has_many :followings, through: :relationships, source: :followee

  def following?(another_user)
    self.followings.include?(another_user)
  end

  def follow(user_id)
    unless self == user_id
      self.relationships.create(followee_id: user_id)
    end
  end

  def unfollow(user_id)
    unless self == user_id
      relationship = self.relationships.find_by(followee_id: user_id)
      relationship.destroy if relationship
    end
  end

end
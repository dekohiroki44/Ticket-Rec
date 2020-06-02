class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name, presence: true, length: { maximum: 50 }
  validates :profile, length: { maximum: 200 }
  has_many :events
  has_one_attached :image
  before_create :default_image
  has_many :active_relationships, class_name: "Relationship",
                                  foreign_key: "follower_id",
                                  dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship",
                                   foreign_key: "followed_id",
                                   dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes, dependent: :destroy
  has_many :comments
  has_many :active_notifications, class_name: 'Notification',
                                  foreign_key: 'visitor_id',
                                  dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification',
                                   foreign_key: 'visited_id',
                                   dependent: :destroy

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Event.where("(user_id IN (#{following_ids}) AND public = :public) OR user_id = :user_id", public: true, user_id: id)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def create_notification_follow!(current_user)
    temp = Notification.
      where(["visitor_id = ? and visited_id = ? and action = ? ", current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end

  def most_places(count)
    events.
      pluck(:place).
      join(",").
      gsub(" ","").
      downcase.split(",").
      group_by { |place| place }.
      sort_by { |_, v| -v.size }.
      map(&:first).
      take(count).
      join(", ")
  end

  def most_artists(count)
    events.
      pluck(:performer).
      join(",").
      gsub(", ",",").
      downcase.
      split(",").
      group_by { |performer| performer }.
      sort_by { |_, v| -v.size }.
      map(&:first).
      take(count).
      join(", ")
  end

  def recommends(count)
    user_ids = Event.
      where('UPPER(performer) LIKE ?', "%#{most_artists(1)}%".upcase).
      where.not(user_id: id).
      pluck(:user_id).
      uniq
      array = []
    user_ids.each do |user_id|
      array << User.find(user_id).events.done.take(5).pluck(:performer).join(",")
    end
    recently_performers = array.join(",").gsub(", ",",").downcase.split(",")
    recently_performers.delete(self.most_artists(1))
    recently_performers.
      group_by { |performer| performer }.
      sort_by { |_, v| -v.size }.
      map(&:first).
      take(count).
      join(", ")
  end

  private

  def default_image
    if !image.attached?
      file = File.open(Rails.root.join('app', 'assets', 'images', 'no_picture.jpg'))
      image.attach(io: file, filename: 'no_picture.jpg', content_type: 'image/jpg')
    end
  end
end

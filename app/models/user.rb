class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  validates :name,  presence: true, length: { maximum: 50 }
  validates :profile, length: { maximum: 200 }
  has_one_attached :image
  before_create :default_image

  private

  def default_image
    if !self.image.attached?
      file = File.open(Rails.root.join('app', 'assets', 'images', 'no_picture.jpg'))
      self.image.attach(io: file, filename: 'no_picture.jpg', content_type: 'image/jpg')
    end
  end
end

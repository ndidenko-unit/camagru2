class Product < ActiveRecord::Base
  acts_as_votable
  validates_presence_of :image
  validate :image_size_validation

  belongs_to :user
  has_many :comments

  mount_base64_uploader :image, ProductImageUploader

  private
  def image_size_validation
    errors[:image] << 'should be less than 500KB' if image.size > 0.5.megabytes
  end
end

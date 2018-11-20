class Product < ActiveRecord::Base
  acts_as_votable
  validates_presence_of :image
  validate :image_size_validation

  scope :order_and_paginate, ->(parameters) { order("updated_at").reverse_order.paginate(parameters) }

  belongs_to :user
  has_many :comments

  mount_base64_uploader :image, ProductImageUploader

  def liked?(current_user)
    self.votes_for.where(voter_id: current_user.id).size > 0
  end

  private
  def image_size_validation
    errors[:image] << 'should be less than 500KB' if image.size > 0.5.megabytes
  end
end

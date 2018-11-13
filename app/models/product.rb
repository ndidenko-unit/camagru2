class Product < ActiveRecord::Base
  belongs_to :user

  mount_base64_uploader :image, ProductImageUploader
end

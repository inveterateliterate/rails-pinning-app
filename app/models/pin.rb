class Pin < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :pinnings, dependent: :destroy
  has_many :users, through: :pinnings

  validates_presence_of :title, :url, :slug, :text, :category_id
  validates_uniqueness_of :slug

  has_attached_file :image, style: { medium: '300x300', thumb: '60x60' }, default_url: 'https://placebear.com/300/300'
  validates_attachment :image, content_type: { content_type: ['image/jpg', 'image/jpeg', 'image/png', 'image/gif'] } if :image?

  accepts_nested_attributes_for :pinnings
end

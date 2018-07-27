class Board < ActiveRecord::Base
  belongs_to :user
  has_many :pinnings, dependent: :destroy
  has_many :pins, through: :pinnings
  has_many :board_pinners, dependent: :destroy

  validates_presence_of :name

  accepts_nested_attributes_for :board_pinners
end

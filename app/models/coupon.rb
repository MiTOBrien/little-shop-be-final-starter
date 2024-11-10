class Coupon < ApplicationRecord
  belongs_to :merchant
  has_one :invoice

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :active, inclusion: [true, false]
  validates :active, exclusion: [nil]
end
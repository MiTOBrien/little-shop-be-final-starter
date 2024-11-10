class Coupon < ApplicationRecord
  belongs_to :merchant
  has_one :invoice

  validates_presence_of :name
end
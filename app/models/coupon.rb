class Coupon < ApplicationRecord
  belongs_to :merchant
  has_one :invoice

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :active, inclusion: [true, false]
  validates :active, exclusion: [nil]

  def self.checkNumber(coupon_params)
    merchant_id = coupon_params[:merchant_id]
    if Coupon.where(merchant_id: merchant_id, active:true).count < 5
      Coupon.create!(coupon_params)
    end
  end
end
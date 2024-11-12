class Coupon < ApplicationRecord
  belongs_to :merchant
  has_one :invoice

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :status, presence: true
  validates :status, acceptance: { accept: ["active", "inactive"] }

  def self.all_by_merchant(merchant_id)
    Coupon.where(merchant_id: merchant_id)
  end
  
  def self.check_number(coupon_params)
    merchant_id = coupon_params[:merchant_id]
    if Coupon.where(merchant_id: merchant_id, status: "active").count < 5
      Coupon.create!(coupon_params)
    end
  end

  def self.check_packaged(params)
    !Invoice.joins(:coupon).where(status: 'packaged', coupon_id: params).exists?
  end
end
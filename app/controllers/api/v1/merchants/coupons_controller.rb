class Api::V1::Merchants::CouponsController < ApplicationController

  def index
    coupons = Coupon.all
    render json: CouponSerializer.new(coupons)
  end

  def show
    coupon = Coupon.find(params[:id])

    render json: CouponSerializer.new(coupon)
  end

  def create
    coupon = Coupon.create!(coupon_params)
    render json: CouponSerializer.new(coupon)
  end

  def update
    coupon = Coupon.find(params[:id])
    coupon.update(coupon_params)
    render json: CouponSerializer.new(coupon)
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :percent_off, :dollars_off, :active, :merchant_id)
  end

end
class Api::V1::Merchants::CouponsController < ApplicationController

  def index
    coupons = Coupon.all_by_merchant(params[:merchant_id].to_i)
    render json: CouponSerializer.new(coupons)
  end

  def show
    coupon = Coupon.find(params[:id])
    render json: CouponSerializer.new(coupon)
  end

  def create
    coupon = Coupon.check_number(coupon_params)
    render json: CouponSerializer.new(coupon)
  end

  def update
    if Coupon.check_packaged(params[:id])
      coupon = Coupon.find(params[:id])
      coupon.update(coupon_params)
      render json: CouponSerializer.new(coupon)
    end
  end

  private

  def coupon_params
    params.require(:coupon).permit(:name, :percent_off, :dollars_off, :status, :merchant_id)
  end

end
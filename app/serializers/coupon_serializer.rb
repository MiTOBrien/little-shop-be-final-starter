class CouponSerializer
  include JSONAPI::Serializer
  set_id :id
  set_type :coupon
  attributes :name, :dollars_off, :percent_off, :active, :merchant_id

  attribute :couut do |coupon|
    Invoice.where.not(coupon_id: nil).count
  end
end
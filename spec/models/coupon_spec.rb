require 'rails_helper'

RSpec.describe Coupon do

  before(:each) do
    @merchant1 = Merchant.create(name: "Little Shop of Horrors")
    @merchant2 = Merchant.create(name: "Large Shop of Wonders")

    @customer1 = Customer.create!(first_name: "Papa", last_name: "Gino")

    @coupon1 = Coupon.create(name: "10Off", dollars_off: 10, status: "active", merchant_id: @merchant1.id)
    @coupon2 = Coupon.create(name: "BOBO50", percent_off: 0.50, status: "inactive", merchant_id: @merchant2.id)

    @invoice1 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "packaged", coupon_id: @coupon1.id)
    @invoice2 = Invoice.create!(customer: @customer1, merchant: @merchant2, status: "shipped", coupon_id: @coupon2.id)
  end

  after(:all) do
    Invoice.delete_all
    Coupon.delete_all
    Customer.delete_all
    Merchant.delete_all
  end

  describe 'relationships' do
    it {should belong_to :merchant}
    it {should have_one :invoice}
  end

  describe 'validations' do
    it {should validate_presence_of(:name)}
    it {should validate_presence_of(:status)}
  end

  describe 'class methods' do
    
    it 'gets coupons for merchant' do
      coupons_by_merchant = Coupon.all_by_merchant(@merchant1.id)
      
      expect(coupons_by_merchant[0].name).to eq(@coupon1.name)
      expect(coupons_by_merchant[0].dollars_off).to eq(@coupon1.dollars_off)
      expect(coupons_by_merchant[0].status).to eq(@coupon1.status)
      expect(coupons_by_merchant[0].merchant_id).to eq(@coupon1.merchant_id)
    end
    
    it 'can check number of coupons' do
      coupon_params = {name: "5Off", dollars_off: 5, status: "active", merchant_id: @merchant1.id}
      check_number = Coupon.check_number(coupon_params)
      
      expect(check_number.name).to eq(coupon_params[:name])
      expect(check_number.dollars_off).to eq(coupon_params[:dollars_off])
      expect(check_number.status).to eq(coupon_params[:status])
      expect(check_number.merchant_id).to eq(coupon_params[:merchant_id])
    end

    it 'can can check for a packaged invoice' do
      coupon = Coupon.create!(name: "BOGO_25", percent_off: 0.25, status: "active", merchant_id: @merchant1.id)
      invoice = Invoice.create!(status: "packaged", coupon_id: coupon.id, customer_id: @customer1.id, merchant_id: @merchant1.id)

      expect(Coupon.check_packaged(coupon.id)).to be false
    end
  end
end
require "rails_helper"

describe "Coupon endpoints" do
  before(:each) do
    @merchant1 = Merchant.create(name: "Little Shop of Horrors")
    @merchant2 = Merchant.create(name: "Large Shop of Wonders")
    @merchant3 = Merchant.create(name: "Wizard's Chest")

    @customer1 = Customer.create!(first_name: "Papa", last_name: "Gino")

    @coupon1 = Coupon.create(name: "10Off", dollars_off: 10, status: "active", merchant_id: @merchant1.id)
    @coupon2 = Coupon.create(name: "BOBO50", percent_off: 0.50, status: "inactive", merchant_id: @merchant1.id)
    @coupon3 = Coupon.create(name: "BOGO100", percent_off: 1.0, status: "active", merchant_id: @merchant2.id)

    @invoice1 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "packaged", coupon_id: @coupon3.id)
    @invoice2 = Invoice.create!(customer: @customer1, merchant: @merchant2, status: "shipped", coupon_id: @coupon3.id)
    @invoice3 = Invoice.create!(customer: @customer1, merchant: @merchant1, status: "shipped", coupon_id: @coupon3.id)
  end

  after(:all) do
    Invoice.delete_all
    Coupon.delete_all
    Merchant.delete_all
  end

  it 'can get all coupons' do
    get "/api/v1/merchants/#{@merchant2.id}/coupons"
    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)
    
    expect(json_response[:data][0][:attributes][:name]).to eq(@coupon3.name)
    expect(json_response[:data][0][:attributes][:dollars_off]).to eq(@coupon3.dollars_off)
    expect(json_response[:data][0][:attributes][:status]).to eq(@coupon3.status)
  end

  it 'can show a coupon' do
    get "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon3.id}"
    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response[:data][:attributes][:name]).to eq(@coupon3.name)
    expect(json_response[:data][:attributes][:percent_off]).to eq(@coupon3.percent_off)
    expect(json_response[:data][:attributes][:status]).to eq(@coupon3.status)
  end

  it 'can create and update a coupon' do
    coupon_params = {name: "5Off", dollars_off: 5, status: "active", merchant_id: @merchant1.id}

    post "/api/v1/merchants/#{@merchant1.id}/coupons", params: {coupon: coupon_params}
    expect(response).to be_successful

    json_response = Coupon.last
    
    expect(json_response.name).to eq("5Off")
    expect(json_response.dollars_off).to eq(5)
    expect(json_response.status).to eq("active")

    # UPDATE COUPON FROM ACTIVE TO INACTIVE
    coupon_params = {status: "inactive"}

    patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{json_response.id}", params: {coupon: coupon_params}
    expect(response).to be_successful

    json_response = Coupon.last
    
    expect(json_response.status).to eq("inactive")

    # UPDATE COUPON FROM INACTIVE TO ACTIVE
    coupon_params = {status: "active"}
    
    patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{json_response.id}", params: {coupon: coupon_params}
    expect(response).to be_successful

    json_response = Coupon.last
    
    expect(json_response.status).to eq("active")
  end
end
require "rails_helper"

describe "Coupon endpoints" do
  before(:each) do
    @merchant1 = Merchant.create(name: "Little Shop of Horrors")
    @merchant2 = Merchant.create(name: "Large Shop of Wonders")
    @merchant3 = Merchant.create(name: "Wizard's Chest")

    @coupon1 = Coupon.create(name: "10Off", dollars_off: 10, active: true, merchant_id: @merchant1.id)
    @coupon2 = Coupon.create(name: "BOBO50", percent_off: 0.50, active: false, merchant_id: @merchant1.id)
    @coupon3 = Coupon.create(name: "BOGO100", percent_off: 1.0, active: true, merchant_id: @merchant2.id)
  end

  after(:all) do
    Coupon.delete_all
    Merchant.delete_all
  end

  it 'can get all coupons' do
    get "/api/v1/merchants/#{@merchant1.id}/coupons"
    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response[:data][0][:attributes][:name]).to eq(@coupon1.name)
    expect(json_response[:data][0][:attributes][:dollars_off]).to eq(@coupon1.dollars_off)
    expect(json_response[:data][1][:attributes][:active]).to eq(@coupon2.active)
  end

  it 'can show a coupon' do
    get "/api/v1/merchants/#{@merchant1.id}/coupons/#{@coupon3.id}"
    expect(response).to be_successful

    json_response = JSON.parse(response.body, symbolize_names: true)

    expect(json_response[:data][:attributes][:name]).to eq(@coupon3.name)
    expect(json_response[:data][:attributes][:percent_off]).to eq(@coupon3.percent_off)
    expect(json_response[:data][:attributes][:active]).to eq(@coupon3.active)
  end

  it 'can create and update a coupon' do
    coupon_params = {name: "5Off", dollars_off: 5, active: true, merchant_id: @merchant1.id}
    headers = {"CONTENT_TYPE" => "application/json"}

    post "/api/v1/merchants/#{@merchant1.id}/coupons", params: {coupon: coupon_params}
    expect(response).to be_successful

    json_response = Coupon.last
    
    expect(json_response.name).to eq("5Off")
    expect(json_response.dollars_off).to eq(5)
    expect(json_response.active).to eq(true)

    # UPDATE COUPON FROM ACTIVE TO INACTIVE
    coupon_params = {active: false}

    patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{json_response.id}", params: {coupon: coupon_params}
    expect(response).to be_successful

    json_response = Coupon.last
    
    expect(json_response.active).to eq(false)

    # UPDATE COUPON FROM INACTIVE TO ACTIVE
    coupon_params = {active: true}
    
    patch "/api/v1/merchants/#{@merchant1.id}/coupons/#{json_response.id}", params: {coupon: coupon_params}
    expect(response).to be_successful

    json_response = Coupon.last
    
    expect(json_response.active).to eq(true)
  end
end
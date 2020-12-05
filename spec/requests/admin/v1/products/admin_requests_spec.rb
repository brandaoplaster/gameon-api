require 'rails_helper'

RSpec.describe "Admin V1 Products as :admin", type: :request do
  let(:logged_in_user) { create(:user) }

  context "GET /products" do
    let(:url) { "/admin/v1/products" }
    let!(:categories) { create_list(:category, 2) }
    let!(:products) { create_list(:product, 10, categories: categories) }

    context "without any params" do
      it "returns 10 records" do
        get url, headers: auth_header(logged_in_user)
        expect(body_json['products'].count).to eq 10
      end
      
      it "returns Products with :productable following default pagination" do
        get url, headers: auth_header(logged_in_user)
        expected_return = products[0..9].map do |product| 
          build_game_product_json(product)
        end
        expect(body_json['products']).to contain_exactly *expected_return
      end

      it "returns success status" do
        get url, headers: auth_header(logged_in_user)
        expect(response).to have_http_status(:ok)
      end
    end

    context "with search[name] param" do
      let!(:search_name_products) do
        products = [] 
        15.times { |n| products << create(:product, name: "Search #{n + 1}") }
        products 
      end

      let(:search_params) { { search: { name: "Search" } } }

      it "returns only seached products limited by default pagination" do
        get url, headers: auth_header(logged_in_user), params: search_params
        expected_return = search_name_products[0..9].map do |product|
          build_game_product_json(product)
        end
        expect(body_json['products']).to contain_exactly *expected_return
      end

      it "returns success status" do
        get url, headers: auth_header(logged_in_user), params: search_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with pagination params" do
      let(:page) { 2 }
      let(:length) { 5 }

      let(:pagination_params) { { page: page, length: length } }

      it "returns records sized by :length" do
        get url, headers: auth_header(logged_in_user), params: pagination_params
        expect(body_json['products'].count).to eq length
      end
      
      it "returns products limited by pagination" do
        get url, headers: auth_header(logged_in_user), params: pagination_params
        expected_return = products[5..9].map do |product|
          build_game_product_json(product)
        end
        expect(body_json['products']).to contain_exactly *expected_return
      end

      it "returns success status" do
        get url, headers: auth_header(logged_in_user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end
    end

    context "with order params" do
      let(:order_params) { { order: { name: 'desc' } } }

      it "returns ordered products limited by default pagination" do
        get url, headers: auth_header(logged_in_user), params: order_params
        products.sort! { |a, b| b[:name] <=> a[:name] }
        expected_return = products[0..9].map do |product|
          build_game_product_json(product)
        end
        expect(body_json['products']).to contain_exactly *expected_return
      end
 
      it "returns success status" do
        get url, headers: auth_header(logged_in_user), params: order_params
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

def build_game_product_json(product)
  json = product.as_json(only: %i(id name description price status))
  json['categories']  = product.categories.map(&:name)
  json['image_url']   = rails_blob_url(product.image)
  json['productable'] = product.productable_type.underscore
  json.merge(product.productable.as_json(only: %i(mode release_date developer)))
end
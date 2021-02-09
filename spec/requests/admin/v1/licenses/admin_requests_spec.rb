require 'rails_helper'

RSpec.describe "Admin V1 Licenses as :admin", type: :request do
  let(:logged_in_user) { create(:user) }
  let(:game) { create(:game) }

  context "GET /games/:game_id/licenses" do
    let(:url) { "/admin/v1/game/#{game.id}/licenses" }
    let!(:licenses) { create_list(:license, 10, game: game) }

    context "without any params" do
      it 'returns 10 Licenses' do
        get url, headers: auth_header(logged_in_user)
        expect(body_json['licenses'].count).to eq(10)
      end

      it 'returns 10 first Licenses' do
        get url, headers: auth_header(logged_in_user)
        expected_licenses = licences[0..9].as_json(only: %i(id))
        expect(body_json['licenses']).to contain_exactly(*expected_licenses)
      end

      it 'returns success status' do
        get url, headers: auth_header(logged_in_user)
        expect(response).to have_http_status(:ok)
      end
    end

    context "pagination params " do
      let(:page) { 2 }
      let(:length) { 5 }
      let(:pagination_params) { { page: page, length: length } }

      it "returns records sized by :length" do
        get url, headers: auth_header(logged_in_user), params: pagination_params
        expect(body_json['licences'].count).to eq length
      end

      it "returns licenses limited by pagination" do
        get url, headers: auth_header(logged_in_user), params: pagination_params
        expected_licenses = licences[5..9].as_json(only: %i(id))
        expect(body_json['licenses']).to contain_exactly *expected_licenses
      end

      it "returns success status" do
        get url, headers: auth_header(logged_in_user), params: pagination_params
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

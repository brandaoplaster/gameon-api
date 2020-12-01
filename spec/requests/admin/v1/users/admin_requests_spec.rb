require 'rails_helper'

RSpec.describe "Admin V1 Users as :admin", type: :request do
  let(:logged_in_user) { create(:user) }

  context "GET /users" do
    let(:url) { "/admin/v1/users" }
    let!(:user_list) { create_list(:user, 10) }

    context "without any params" do
      it "returns 10 users" do
        get url, headers: auth_header(logged_in_user)
        expect(body_json['users'].count).to eq(10)
      end
      
      it "returns 10 first users" do
        get url, headers: auth_header(logged_in_user)
        expected_users = user_list[0..9].as_json(only: %i(id name email profile))
        expect(body_json['users']).to contain_exactly(*expected_users)
      end

      it "returns success status" do
        get url, headers: auth_header(logged_in_user)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end

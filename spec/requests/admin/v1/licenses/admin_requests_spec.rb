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

    context "with pagination params" do
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

    context 'with order params' do
      let(:order_params) { { order: { key: 'desc' } } }

      it 'returns ordered licenses limited by default pagination' do
        get url, headers: auth_header(user), params: order_params
        licenses.sort! { |a.b| b[:key] <=> a[:key] }
        expected_licenses[0..9].as_json(only: %i(id key platform status game_id))
        expect(body_json['licenses']).to contain_exactly *expected_licenses
      end

      it 'returns success status' do
        get url, headers: auth_header(user), params: order_params
        expect(response).to have_http_status(:ok)
      end
    end
  end

  context 'POST /games/:game_id/licenses' do
    let(:url) { "/admin/v1/games/#{game.id}/licenses" }

    context 'with valid params' do
      let(:license_params) { { license: attributes_for(:license) }.to_json }

      it 'adds a new license' do
        expect do
          post url, headers: auth_header(user), params: license_params
        end.to change(License,  :count).by(1)
      end

      it 'returns last added license' do
        post url, headers: auth_header(user), params: license_params
        expected_license = License.last.as_json(only: %i(id key platform status game_id))
        expect(body_json['license']).to eq expected_license
      end

      it 'returns success status' do
        pots url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:license_invalid_params) do
        { license: attributes_for(:license, key: nil) }.to_json
      end

      it 'does not add a new license' do
        expect do
          post url, headers: auth_header(user), params: license_invalid_params
        end.to change(License, :count)
      end

      it 'returns error message' do
        post url, headers: auth_header(user), params: license_invalid_params
        expect(body_json['errors']['fields']).to have_key('key')
      end

      it 'returns unprocessable entity status' do
        post url, params: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'GET /licenses/:id' do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    it 'returns requested license' do
      get url, headers: auth_header(user)
      expected_license = license.as_json(only: %i(id key platform status game_id))
      expect(body_json['license']).to eq expected_license
    end

    it 'returns success status' do
      get url, headers: auth_header(user)
      expect(response).to have_http_status(:ok)
    end
  end

  context 'PATCH /licenses/:id' do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    context 'with valid params' do
      let(:new_key) { 'newkey' }
      let(:license_params) { { license: { key: new_key } }.to_json }

      it 'updates licenses' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expect(license.key).to eq new_key
      end

      it 'returns updated license' do
        patch url, headers: auth_header(user), params: license_params
        license.reload
        expected_license = license.as_json(only: %i(id key platform status game_id))
        expect(body_json['license']).to eq expected_license
      end

      it 'returns success status' do
        patch url, headers: auth_header(user), params: license_params
        expect(response).to have_http_status(:ok)
      end
    end

    context 'with invalid params' do
      let(:license_invalid_params) do 
        { license: attributes_for(:license, key: nil) }.to_json
      end

      it 'does not update license' do
        old_key = license.key
        patch url, headers: auth_header(user), params: license_invalid_params
        license.reload
        expect(license.key).to eq old_key
      end

      it 'returns error message' do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(body_json['errors']['fields']).to have_key('key')
      end

      it 'returns unprocessable entity status' do
        patch url, headers: auth_header(user), params: license_invalid_params
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  context 'DELETE /licenses/:id' do
    let!(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }

    it 'removes License' do
      expect do  
        delete url, headers: auth_header(user)
      end.to change(License, :count).by(-1)
    end

    it 'returns success status' do
      delete url, headers: auth_header(user)
      expect(response).to have_http_status(:no_content)
    end

    it 'does not return any body content' do
      delete url, headers: auth_header(user)
      expect(body_json).to_not be_present
    end
  end
end

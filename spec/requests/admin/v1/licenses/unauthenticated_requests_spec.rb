require 'rails_helper'

RSpec.describe "Admin V1 Licenses as :client", type: :request do
  let(:game) { create(:game) }
  
  context 'GET /games/:game_id/licenses' do
    let(:url) { "/admin/v1/games/#{game.id}/licenses" }
    let!(:license) { create_list(:license, 5) }
    before(:each) { get url }
    include_examples "unauthenticated access"
  end

  context 'GET /licenses/:id' do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }
    before(:each) { get url }
    include_examples "unauthenticated access"
  end

  context 'POST /games/:games_id/licenses' do
    let(:url) { "/admin/games/#{game.id}/licenses" }
    before(:each) { post url }
    include_examples "unauthenticated access"
  end

  context 'PATCH /licenses/:id' do
    let(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }
    before(:each) { patch url }
    include_examples "unauthenticated access"
  end

  context 'DELETE /licenses/:id' do
    let!(:license) { create(:license) }
    let(:url) { "/admin/v1/licenses/#{license.id}" }
    before(:each) { delete url}
    include_examples "unauthenticated access"
  end
end

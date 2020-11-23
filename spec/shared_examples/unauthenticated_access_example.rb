shared_examples "unauthenticated access" do
  it "returns unauthenticated status" do
    expect(response).to have_http_status(:unauthorized)
  end
end
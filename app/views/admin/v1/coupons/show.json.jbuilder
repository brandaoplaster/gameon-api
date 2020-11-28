json.coupon do
  json.(@coupon, :id, :name, :code, :status, :discount_value, :max_user, :due_date)
end

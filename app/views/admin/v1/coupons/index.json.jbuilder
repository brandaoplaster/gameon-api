json.coupons do
  json.array! @coupons, :id, :name, :code, :status, :discount_value, :max_user, :due_date
end
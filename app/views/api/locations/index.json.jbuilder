json.cache! @locations, expires_in: cache_time do
  json.array! @locations, :id, :name, :description, :address_street, :address_zip, :address_city
end

json.cache! [@categories, @year], expires_in: 10.minutes do
  json.array! @categories, partial: 'api/categories/category', as: :category
end

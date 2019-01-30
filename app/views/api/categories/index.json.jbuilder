json.cache! @categories, expires_in: cache_time do
  json.array! @categories, partial: 'category', as: :category, locals: { with_children: false }
end

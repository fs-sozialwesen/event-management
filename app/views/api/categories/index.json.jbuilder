json.cache! @categories, expires_in: cache_time do
  json.array! @categories, partial: 'category', as: :category, locals: { children_depth: 0 }
end

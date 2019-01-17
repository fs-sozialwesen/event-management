json.cache! [@categories, @year], expires_in: cache_time do
  json.array! @categories, partial: 'category', as: :category, locals: { with_children: true }
end

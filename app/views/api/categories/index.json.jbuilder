json.array! @categories do |category|
  json.(category, :id, :number, :name, :year, :parent_id, :position)
end

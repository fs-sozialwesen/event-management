json.cache! [@categories, @filter], expires_in: 10.minutes do
  json.array! @categories do |category|
    json.(category, :id, :number, :name, :year, :parent_id, :position)
    json.number_seminars_direct category.seminars.count
    json.number_seminars_inherited category.all_seminars.count
    json.number_children category.children.count
    json.number_descendants category.descendants.count - 1
    json.path category.path.map(&:id).join '/'
    json.level category.path.size
  end
end

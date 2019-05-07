json.(category, :id, :number, :name, :year, :parent_id, :position)
json.abs_position              category.path.map(&:position).join('.')
json.number_seminars_direct    category.seminars.published.count
json.number_seminars_inherited category.all_seminars.published.count
json.number_children           category.children.count
json.number_descendants        category.descendants.count - 1
json.level                     category.path.size
json.link                      api_category_url(category.id, format: :json)
json.path category.path do |cat|
  json.(cat, :id, :number, :name)
  json.link api_category_url(cat.id, format: :json)
end
if children_depth > 0
  json.children category.children, partial: 'category', as: :category, locals: { children_depth: children_depth - 1 }
end

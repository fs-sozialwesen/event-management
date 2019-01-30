children_count = category.children.count
json.(category, :id, :number, :name, :year, :parent_id, :position)
json.abs_position              category.path.map(&:position).join('.')
json.number_seminars_direct    category.seminars.count
json.number_seminars_inherited category.all_seminars.count
json.number_children           children_count
json.number_descendants        category.descendants.count - 1
json.path                      category.path, :id, :number, :name
json.level                     category.path.size
json.children_url              children_count.positive? ? api_category_url(category.id, format: :json) : nil
if with_children
  json.children category.children, partial: 'category', as: :category, locals: { with_children: true }
end

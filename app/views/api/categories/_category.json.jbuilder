json.(category, :id, :number, :name, :year, :parent_id, :position)
json.number_seminars_direct    category.seminars.count
json.number_seminars_inherited category.all_seminars.count
json.number_children           category.children.count
json.number_descendants        category.descendants.count - 1
json.path                      category.path.map(&:id).join '/'
json.level                     category.path.size
if with_children
  json.children category.children, partial: 'category', as: :category, locals: { with_children: true }
end

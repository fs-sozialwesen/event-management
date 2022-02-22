json.cache! [@seminars, @filter], expires_in: cache_time do
  json.array! @seminars do |seminar|
    json.cache! seminar, expires_in: cache_time do
      json.link api_seminar_url(seminar.id, format: :json)
      json.(seminar, :id, :number, :title, :subtitle, :recommended, :recommendation_label)
      json.location   seminar.location, :id, :name
      json.bookable   seminar.bookable?
      json.categories(seminar.categories.map { |cat| cat.attributes.slice('name', 'number', 'position', 'parent_id') })
      json.start_date seminar.date
      json.dates      seminar.decorate.dates
      json.events     seminar.events, :date, :start_time, :end_time
      json.teachers   seminar.teachers.map(&:name)
      json.price      seminar.price&.to_f
      json.price_text strip_tags(seminar.price_text)
    end
  end
end

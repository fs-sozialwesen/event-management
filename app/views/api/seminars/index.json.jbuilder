json.cache! [@seminars, @year, @category, @page, @per_page], expires_in: 10.minutes do
  json.array! @seminars do |seminar|
    json.link api_seminar_url(seminar.id)
    json.(seminar, :id, :number, :title, :subtitle, :category_ids)
    json.start_date seminar.date
    json.dates seminar.decorate.dates
    json.events seminar.events, :date, :start_time, :end_time
    json.teachers seminar.teachers.map(&:name)
  end
end


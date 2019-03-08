json.cache! @seminar, expires_in: cache_time do

  json.extract!         @seminar, :id, :title, :subtitle, :number, :recommended, :recommendation_label
  json.admin_url        admin_seminar_url(@seminar)
  json.booking_url      @seminar.booking_address
  json.external_booking @seminar.external_booking_address.present?

  json.content @seminar.content&.to_json
  json.benefit @seminar.benefit&.to_json
  json.notes   @seminar.notes&.to_json


  json.date_text       @seminar.has_date_text? ? @seminar.date_text.to_json : nil
  json.formatted_dates(@seminar.events_list.map { |date, time| { date: date, time: time } })
  json.events          @seminar.events, :date, :start_time, :end_time
  json.teachers        @seminar.teachers, :name, :profession

  json.location @seminar.location, :id, :name
  json.price_text @seminar.price_text&.to_json

  json.bookable          @seminar.bookable?
  json.pre_bookable      @seminar.early_reducible?
  json.pre_bookable_text @seminar.early_reducible? ? t('seminars.pre_bookable_text', weeks: @seminar.pre_booking_weeks) : nil

  json.due_date @seminar.due_date.present? ? @seminar.due_date.to_json : nil

end

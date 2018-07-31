class SeminarPolicy < ApplicationPolicy
  alias seminar record

  who_can(:index?)           { editor? || layouter? || finance? }
  who_can(:category?)        { editor? || layouter? || finance? }
  who_can(:date?)            { editor? || layouter? || finance? }
  who_can(:calendar?)        { editor? || layouter? || finance? }
  who_can(:canceled?)        { editor? }
  who_can(:filter?)          { editor? || layouter? || finance? }
  who_can(:editing_status?)  { editor? || layouter? }
  who_can(:show?)            { editor? || layouter? || finance? }
  who_can(:create?)          { editor? }
  who_can(:update?)          { editor? || (layouter? && !seminar.published? && !seminar.catalog.published?) }
  who_can(:attendees?)       { editor? || finance? }
  who_can(:pras?)            { admin? }
  who_can(:versions?)        { editor? || layouter? }
  who_can(:toggle_category?) { editor? }
  who_can(:search?)          { editor? }
  who_can(:publish?)         { editor? }
  who_can(:unpublish?)       { publish? }
  who_can(:finish_editing?)  { editor? }
  who_can(:finish_layout?)   { layouter? }

  def permitted_attributes
    attrs = %i[title subtitle benefit content notes date_text location_id editor_id external_booking_address]
    if editor?
      attrs += %i[number price price_text key_words parent_id max_attendees archived canceled copy_from_id year]

      attrs << {
        teacher_ids: [],
        events_attributes: %i[id location_id date start_time end_time notes _destroy],
        legal_statistic_attributes: LegalStatistic.column_names
      }
    end
    attrs
  end
end

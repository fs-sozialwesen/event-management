class Event < ApplicationRecord

  belongs_to :seminar, optional: true
  belongs_to :location, optional: true

  # validates :date, presence: true

  has_paper_trail

  def time
    "#{start_time} - #{end_time}"
  end

end

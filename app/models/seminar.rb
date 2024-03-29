# frozen_string_literal: true

class Seminar < ApplicationRecord

  COURSE_REGEX  = /(K)(\d+)-(.*)/
  SEM_REGEX     = /([A-Z])-(\d+)-(.*)/
  NUMBER_FORMAT = /\A[A-Z]-\d{3}-\d{2}(A\d)?[A-Z].*\Z/

  include PgSearch::Model

  belongs_to :catalog, foreign_key: :year, primary_key: :year, inverse_of: :seminars
  belongs_to :editor, class_name: 'User'
  has_and_belongs_to_many :teachers
  has_and_belongs_to_many :categories
  belongs_to :location, optional: true
  has_many :events, -> { order :date }
  belongs_to :parent,    class_name: 'Seminar', inverse_of: :sub_modules
  has_many :sub_modules, class_name: 'Seminar', inverse_of: :parent, foreign_key: :parent_id
  has_many :bookings
  has_many :attendees, -> { booked }, inverse_of: :seminar
  has_many :all_attendees, class_name: 'Attendee'
  has_many :invoices, inverse_of: :seminar
  belongs_to :original, class_name: 'Seminar', foreign_key: 'copy_from_id', inverse_of: :copies
  has_many :copies,     class_name: 'Seminar', foreign_key: 'copy_from_id', inverse_of: :original
  has_one :legal_statistic, inverse_of: :seminar, dependent: :destroy

  accepts_nested_attributes_for(
    :events,
    allow_destroy: true,
    reject_if:     ->(attr) { attr['date'].blank? }
  )
  accepts_nested_attributes_for :legal_statistic

  validates :number, presence: true, uniqueness: true
  validates :number, format: NUMBER_FORMAT, on: :create
  validates :title, presence: true
  validates :year, presence: true, inclusion: { in: proc { Catalog.pluck :year } }
  # validate :validate_events
  validate :editor_is_editor
  validates :pre_booking_weeks, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  before_save :set_date

  default_scope { where archived: false }

  scope :archived,  -> { unscoped.where archived: true }
  scope :published, -> { where published: true, canceled: false }
  scope :canceled,  -> { where canceled:  true }
  scope :bookable,  -> { published.where 'COALESCE(bookable_until, date) >= CURRENT_DATE' }
  scope :overdue,   -> { published.where 'COALESCE(bookable_until, date) < CURRENT_DATE' }
  scope :by_year_and_month, lambda { |year, month|
    if month.zero?
      where(date: [nil, '']).where(year: year)
    else
      start_date = Date.new year, month
      where(id: Event.where(date: start_date..start_date.end_of_month).select(:seminar_id))
    end
  }
  scope :recommended,          -> { where recommended: true }
  scope :editing_finished,     -> { where.not editing_finished_at: nil }
  scope :editing_not_finished, -> { where     editing_finished_at: nil }
  scope :layout_finished,      -> { where.not layout_finished_at:  nil }
  scope :layout_not_finished,  -> { where     layout_finished_at:  nil }

  scope :layout_open,          -> { editing_finished.layout_not_finished }
  scope :all_finished,         -> { editing_finished.layout_finished }
  scope :completed,            -> { all_finished.where('editing_finished_at < layout_finished_at') }
  scope :editing_changed,      -> { all_finished.where('editing_finished_at > layout_finished_at') }

  scope :by_number, ->(filter) {
    where('number ilike ?', "#{filter[:number1]}%#{filter[:number2].tr('*', '%')}-%#{filter[:number3]}%")
  }

  search_fields = %i(number title subtitle benefit content notes due_date price_text key_words)
  ext_search_fields = {
    seminars: search_fields,
    locations: [:name],
    teachers: %i(first_name last_name title)
  }

  # @param q String 'hallo tom'
  # search_words = { q0: '%hallo%', q1: '%tom%' }
  # (number ilike :q0 OR title ilike :q0 OR ... OR location.name ilike :q0) AND (number ilike :q1 OR title ...) AND ...
  # (number ilike %hallo% OR title ilike %hallo% OR ... OR location.name ilike %hallo%) AND (number ilike %tom% OR title ...) AND ...
  scope :ext_search, ->(q) {
    search_words  = q.to_s.split(' ').map.with_index { |word, index| [:"q#{index}", "%#{word}%"] }.to_h
    expression = search_words.keys.map do |key|
      ext_search_fields.flat_map { |table, fields| fields.map { |field| "#{table}.#{field} ilike :#{key}" } }.join(' OR ')
    end.map { |exp| "(#{exp})" }.join(' AND ')
    joins(:location, :teachers).where(expression, search_words)
  }

  has_paper_trail

  associated_fields = {
    teachers:   %i(first_name last_name profession),
    categories: %i(name),
    location:   %i(name description address)
  }
  multisearchable against: search_fields
  pg_search_scope :external_search, against: search_fields, associated_against: associated_fields

  def self.grouped_numbers(year = Date.current.year)
    numbers = where(year: year).order(:number).pluck(:number).map { |num| split_number num, year }.compact
    numbers.each_with_object({}) do |(first, second, third), grouped|
      grouped[first] ||= {}
      grouped[first][second] ||= []
      grouped[first][second] << third
    end
  end

  def self.split_number(number, year)
    return unless number
    regex = year < 2019 && number[0] == 'K' ? COURSE_REGEX : SEM_REGEX
    number.scan(regex)&.first
  end

  def cache_key
    [super, bookable?].join '/'
  end

  def name
    title
  end

  def to_param
    "#{id}-#{slug}"
  end

  def slug
    I18n.transliterate(name.downcase).delete('"').gsub(/[^a-z0-9]+/, '-')
  end

  def bookable?
    published && (bookable_until || date) >= Date.current
  end

  def reducible?
    early_reducible? || tandem_reducible? || pari_reducible? || group_reducible? || school_reducible?
  end

  def early_reducible?
    pre_booking_weeks.to_i.positive?
  end

  def editing_finished?
    editing_finished_at.present?
  end
  alias editing_finished editing_finished?

  def layout_finished?
    layout_finished_at.present?
  end
  alias layout_finished layout_finished?

  def editing_changed?
    editing_finished? && layout_finished? && editing_finished_at > layout_finished_at
  end

  private

  def editor_is_editor
    errors.add(:editor, :must_be_an_editor) if editor.present? && !editor.editor?
  end

  def validate_events
    errors.add(:events, :too_few) if events.empty?
  end

  def set_date
    return unless events.any?
    self.date = events.map(&:date).min
  end

end

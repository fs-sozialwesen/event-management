class Booking < ApplicationRecord

  enum status: { created: 0, canceled: 1 }

  attr_accessor :external

  belongs_to :seminar
  has_many :attendees
  belongs_to :company

  acts_as_addressable field_name: :invoice_address, prefix: :invoice
  acts_as_addressable field_name: :company_address, prefix: :company
  acts_as_contactable
  accepts_nested_attributes_for :attendees, allow_destroy: true

  validate :validate_attendees
  validates :data_protection, acceptance: true
  validates :terms_of_service, acceptance: true
  validates :contact_phone, presence: true, if: :external
  validates :invoice_title, :invoice_street, :invoice_zip, :invoice_city, presence: true, if: :external
  validates :tandem_address, :tandem_company, :tandem_name,
    presence: true,
    if: proc { |booking| booking.reduction.to_s == 'tandem' }
  validates :school, :year,
    presence: true,
    if: proc { |booking| booking.reduction.to_s == 'school' }

  before_validation { |booking| booking.invoice_title = booking.attendees&.first&.name unless booking.is_company }
  before_save { |booking| booking.graduate = booking.reduction.to_s == 'school' }

  has_paper_trail

  def name
    ''
  end

  private

  def validate_attendees
    errors.add(:attendees, :too_few) if attendees.empty? || (reduction.to_s == 'group' && attendees.size < 5)
  end

end

class Attendee < ApplicationRecord
  include PgSearch::Model

  enum status: { booked: 0, canceled: 1, attended: 2 }

  belongs_to :seminar, inverse_of: :attendees
  belongs_to :booking, inverse_of: :attendees
  belongs_to :invoice, inverse_of: :attendees
  belongs_to :company, inverse_of: :attendees
  belongs_to :canceled_by, class_name: 'User'

  acts_as_addressable
  acts_as_contactable
  acts_as_addressable field_name: :invoice_address, prefix: :invoice
  acts_as_addressable field_name: :company_address, prefix: :company

  validates :first_name, :last_name, presence: true

  before_save { |attendee| attendee.graduate = attendee.reduction.to_s == 'school' }

  has_paper_trail

  multisearchable against: %i(first_name last_name address contact)

  def name
    "#{first_name} #{last_name}"
  end

  def full_address
    [name, address.street, "#{address.zip} #{address.city}"].join("\n")
  end

  def cancel!(reason:, user:)
    canceled!
    update cancellation_reason: reason, canceled_by: user
  end
end

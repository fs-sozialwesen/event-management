class Company < ApplicationRecord
  include PgSearch::Model

  has_many :bookings, inverse_of: :company, dependent: :restrict_with_error
  has_many :attendees, inverse_of: :company, dependent: :restrict_with_error
  has_many :invoices, inverse_of: :company, dependent: :restrict_with_error

  has_many :seminars, through: :attendees
  has_many :categories, through: :seminars

  validates :name, presence: true

  multisearchable against: %i[name name2 city city_part]

  def address
    [city_part, street, "#{zip} #{city}"].compact.join "\n"
  end

  def full_name
    [name, name2].compact.join "\n"
  end

  def full_address
    "#{full_name}\n#{address}"
  end

end

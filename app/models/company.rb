class Company < ApplicationRecord
  include PgSearch

  has_many :bookings, inverse_of: :company
  has_many :attendees, inverse_of: :company
  has_many :invoices, inverse_of: :company

  validates :name, presence: true

  multisearchable against: [:name, :name2, :city, :city_part]

  def address
    [street, "#{zip} #{city}", city_part].compact.join "\n"
  end

  def full_name
    [name, name2].compact.join "\n"
  end

  def full_address
    "#{full_name}\n#{address}"
  end

end

class Catalog < ApplicationRecord
  validates :title, presence: true
  validates :year, presence: true, uniqueness: true

  # has_many :categories, foreign_key: :year, primary_key: :year, inverse_of: :catalog
  has_many :seminars,   foreign_key: :year, primary_key: :year, inverse_of: :catalog

  default_scope -> { order :year }
  scope :published, -> { where published: true }

  has_attached_file :print_version
  validates_attachment_content_type :print_version, content_type: ['application/pdf']

  def date_range(month = nil)
    if month
      date = Date.new year, month
      date..date.end_of_month
    else
      date = Date.new year
      date..date.end_of_year
    end
  end
end

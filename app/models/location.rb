class Location < ApplicationRecord

  include PgSearch::Model

  has_many :seminars

  validates :name, presence: true

  acts_as_addressable

  has_paper_trail

  multisearchable against: [:name, :description, :address]

end

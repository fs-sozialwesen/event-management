class Teacher < ApplicationRecord

  include PgSearch::Model

  has_and_belongs_to_many :seminars

  validates :last_name, presence: true

  acts_as_addressable
  acts_as_contactable

  has_paper_trail

  multisearchable against: %i[title first_name last_name profession skill_sets remarks]

  def name
    [title, first_name, last_name].select(&:present?).join(' ')
  end

end

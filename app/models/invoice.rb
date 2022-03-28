class Invoice < ApplicationRecord
  enum status: { created: 0, sent: 1, payed: 2 }

  has_many :attendees, inverse_of: :invoice
  belongs_to :seminar, inverse_of: :invoices, optional: true
  belongs_to :company, inverse_of: :invoices, optional: true

  serialize :items, InvoiceItems

  validates :number, :date, presence: true
  validates :number, uniqueness: true

  has_paper_trail

  def name
    number
  end

  def total_price
    items.sum
  end

  def self.next_number
    invoice = order(number: :desc).first
    invoice ? invoice.number.next : "#{Date.current.year}00001"
  end

  def self.next(attrs)
    new default_attributes.merge(attrs)
  end

  def self.default_attributes
    {
      number:       next_number,
      date:         Date.current,
      pre_message:  I18n.t('invoices.default_pre_message'),
      post_message: I18n.t('invoices.default_post_message')
    }
  end

end

class InvoiceGenerator

  def self.new_invoices_for(seminar)
    company_invoices_for(seminar) + attendee_invoices_for(seminar)
  end

  def self.call(attendee: nil, company: nil, seminar: nil)
    return generate_for_single(attendee)  if attendee.present?
    return generate_for(company, seminar) if [company, seminar].all?(&:present?)
    raise ArgumentError, 'Attendee or company and seminar must be given'
  end

  private

  def self.generate_for_single(attendee)
    new_invoice address: attendee.invoice_address.full_address, seminar: attendee.seminar, attendees: [attendee]
  end

  def self.generate_for(company, seminar)
    attendees = seminar.attendees.where(company: company)
    new_invoice address: company.full_address, seminar: seminar, attendees: attendees, company: company
  end

  def self.new_invoice(address:, seminar:, attendees:, company: nil)
    reductions = 0
    items = attendees.map do |attendee|
      name = attendee.name
      if attendee.reduction.present?
        reductions += 1
        name += " (#{I18n.t('buchung.reductions')[attendee.reduction.to_sym]})"
      end
      { attendee: name, price: seminar.price || 0 }
    end
    items << { attendee: "Rabatt für #{reductions} Person(en)", price: 0 } if reductions.positive?
    Invoice.next(address: address, seminar: seminar, attendees: attendees, company: company, items: items)
  end

  def self.attendee_invoices_for(seminar)
    seminar.attendees.where(invoice_id: nil, company_id: nil).map { |attendee| generate_for_single attendee }
  end

  def self.company_invoices_for(seminar)
    companies = Company.where(id: seminar.attendees.where(invoice_id: nil).select(:company_id))
    companies.map { |company| generate_for company, seminar }
  end

end

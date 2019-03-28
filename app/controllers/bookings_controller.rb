class BookingsController < ApplicationController

  MAX_ATTENDEES = 16

  def new
    @seminar = Seminar.published.find(params[:seminar_id]).decorate
    @booking = @seminar.bookings.build is_company: true
    MAX_ATTENDEES.times { @booking.attendees.build }
  end

  def create
    # return redirect_to root_url unless request_origin_valid?
    @booking = Booking.new booking_params
    @booking.ip_address = request.remote_ip
    @booking.external = true
    copy_fields_to_attendees

    if @booking.save
      BookingMailer.booking_notification_email(@booking).deliver_later
      BookingMailer.booking_confirmation_email(@booking).deliver_later
      redirect_to booking_show_url(@booking)
    else
      @seminar = Seminar.find(@booking.seminar_id).decorate
      MAX_ATTENDEES.times { @booking.attendees.build }
      render :new
    end
  end

  def show
    @booking = Booking.find params[:booking_id]
    @seminar = @booking.seminar.decorate
  end

  private

  def request_origin_valid?
    ip_info = JSON.parse Net::HTTP.get('freegeoip.net', "/json/#{request.remote_ip}")
    ip_info['country_code'] == 'DE'
  end

  def copy_fields_to_attendees
    attributes = %w(
      seminar_id contact company_address invoice_address member member_institution school year graduate comments
      reduction tandem_name tandem_company tandem_address is_company
    )
    attributes = @booking.attributes.slice(*attributes)
    @booking.attendees.each { |attendee| attendee.assign_attributes attributes }
  end

  def booking_params
    attrs = [
      :seminar_id, :member, :member_institution, :graduate, :school, :year, :reduction,
      :contact_email, :contact_phone, :contact_mobile, :contact_fax, :comments,
      :company_title, :company_street, :company_zip, :company_city,
      :invoice_title, :invoice_street, :invoice_zip, :invoice_city, :is_company,
      :data_protection, :terms_of_service, :tandem_name, :tandem_company, :tandem_address,
      attendees_attributes: %i(first_name last_name profession)
    ]
    p = params.require(:booking).permit(attrs)
    p['attendees_attributes'].reject! do |_, attr|
      attr['first_name'].blank? && attr['last_name'].blank?
    end
    p
  end

end

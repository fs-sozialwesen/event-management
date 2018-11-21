class BookingMailer < ApplicationMailer

  def booking_confirmation_email(booking)
    @booking = booking
    @seminar = booking.seminar.decorate
    subject  = 'PBW GmbH - Seminaranmeldung'
    mail to: booking.contact_email, subject: subject
  end

  def booking_notification_email(booking)
    @booking = booking
    @seminar = booking.seminar.decorate
    mail(to: Setting.new_booking_email, subject: 'Neue Seminaranmeldung')
  end

  def attendee_canceled_email(attendee)
    @attendee = attendee
    @seminar  = attendee.seminar
    @user     = attendee.canceled_by
    subject   = "Anmeldung storniert für #{@seminar.number}"
    mail(to: Setting.new_booking_email, subject: subject)
  end
end

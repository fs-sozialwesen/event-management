# Preview all emails at http://localhost:3000/rails/mailers/booking_mailer
class BookingMailerPreview < ActionMailer::Preview
  def booking_confirmation_email
    BookingMailer.booking_confirmation_email Seminar.find(299).bookings.last
  end

  def booking_notification_email
    BookingMailer.booking_notification_email Booking.last
  end

  def attendee_canceled_email
    BookingMailer.attendee_canceled_email Attendee.canceled.last
  end
end

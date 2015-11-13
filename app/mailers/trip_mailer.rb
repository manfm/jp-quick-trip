class TripMailer < ApplicationMailer
  # *params*
  # * Hash trip - detail of trip from Api.get_trip_detail
  # * String email_address - email of recepient
  def send_trip(trip, email_address)
    @trip = trip
    mail(to: email_address, subject: "New trip '#{trip['title']}'")
  end
end

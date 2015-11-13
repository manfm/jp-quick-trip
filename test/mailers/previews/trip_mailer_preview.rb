# Preview all emails at http://localhost:3000/rails/mailers/trip_mailer
class TripMailerPreview < ActionMailer::Preview
  def send_trip_preview
    data = JSON.parse(File.read('test/odigo/trip_response.json'))
    TripMailer.send_trip data['response'], 'my@email.com'
  end
end

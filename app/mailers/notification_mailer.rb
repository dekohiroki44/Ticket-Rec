class NotificationMailer < ApplicationMailer
  default from: 'noreply@ticket-rec.com'

  def send_mail(user)
    @user = user
    tomorrow = DateTime.tomorrow.to_datetime - 9.hour
    @tickets = @user.tickets.where(date: tomorrow..tomorrow + 1.day)
    mail(
      subject: "明日、予定しているチケットがあります。",
      to: @user.email
    ) do |format|
      format.html
    end
  end
end

module UsersHelper
  def set_mail
    tomorrow = DateTime.tomorrow.to_datetime - 9.hour
    user_ids = Ticket.where(date: tomorrow..tomorrow + 1.day).pluck(:user_id).uniq
    user_ids.each do |user_id|
      user = User.find(user_id)
      NotificationMailer.send_mail(user).deliver
    end
  end
end

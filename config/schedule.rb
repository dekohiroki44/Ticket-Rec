require File.expand_path(File.dirname(__FILE__) + "/environment")

env :PATH, ENV['PATH']
# set :environment, :development
set :output, 'log/cron.log'
ENV.each { |k, v| env(k, v) }

# every 1.days, at: '12:00 am' do
every 3.minutes do
  runner "User.set_tomorrow_ticket_mail"
end

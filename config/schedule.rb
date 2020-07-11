require File.expand_path(File.dirname(__FILE__) + "/environment")

env :PATH, ENV['PATH']
set :environment, :production
set :output, 'log/cron.log'
ENV.each { |k, v| env(k, v) }

every 1.days, at: '7:15 pm' do
  runner "User.update_and_mail_of_tomorrow"
end

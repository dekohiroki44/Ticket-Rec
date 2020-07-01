require File.expand_path(File.dirname(__FILE__) + "/environment")

ENV.each { |k, v| env k.to_sym, v }

set :environment, Rails.env.to_sym
set :output, "#{Rails.root}/log/cron.log"

every 1.days, at: '14:45 am' do
  runner "UsersController.set_mail"
end

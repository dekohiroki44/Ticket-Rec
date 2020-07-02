require File.expand_path(File.dirname(__FILE__) + "/environment")

rails_env = Rails.env.to_sym
rails_root = Rails.root.to_s
set :environment, rails_env
set :output, "#{rails_root}/log/cron.log"

every 1.days, at: '14:45 am' do
  runner "UserHelper.set_mail"
end

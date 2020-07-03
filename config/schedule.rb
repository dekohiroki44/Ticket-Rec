require File.expand_path(File.dirname(__FILE__) + "/environment")

env :PATH, ENV['PATH']
rails_env = Rails.env.to_sym
rails_root = Rails.root.to_s
set :environment, rails_env
set :output, "#{rails_root}/log/cron.log"
ENV.each { |k, v| env(k, v) }

every 1.days, at: '14:45 am' do
  runner "UserHelper.set_mail"
end

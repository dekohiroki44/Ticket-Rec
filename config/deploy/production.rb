server '54.95.141.117', user: 'hiroki', roles: %w(app db web)
set :ssh_options, keys: ["#{ENV['PRODUCTION_SSH_KEY']}"]

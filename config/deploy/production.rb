# EC2サーバーのIP、EC2サーバーにログインするユーザー名、サーバーのロールを記述
server 'ticket-rec.com', user: 'hiroki', roles: %w{app db web}

# デプロイするサーバーにsshログインする鍵の情報を記述
set :ssh_options, keys: '~/.ssh/ticket-rec_key_rsa'

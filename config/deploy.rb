lock "~> 3.14.1"

set :application, "Ticket-Rec"
set :repo_url, 'git@github.com:dekohiroki44/Ticket-Rec.git'
set :branch, 'master'
set :deploy_to, '/var/www/rails/Ticket-Rec'
set :linked_files, %w(config/master.key)
set :linked_files, fetch(:linked_files, []).push('config/secrets.yml')
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')
set :keep_releases, 5
set :rbenv_ruby, '2.5.1'
set :log_level, :debug
set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do
  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  desc 'Create database'
  task :db_create do
    on roles(:db) do |host|
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:create'
        end
      end
    end
  end

  desc 'Run seed'
  task :seed do
    on roles(:app) do
      with rails_env: fetch(:rails_env) do
        within current_path do
          execute :bundle, :exec, :rake, 'db:seed'
        end
      end
    end
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end
end

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  desc 'upload master.key'
  task :upload do
    on roles(:app) do |host|
      if test "[ ! -d #{shared_path}/config ]"
        execute "mkdir -p #{shared_path}/config"
      end
      # upload!('config/master.key', "#{shared_path}/config/master.key")
    end
  end

  before :starting, 'deploy:upload'
  after :finishing, 'deploy:cleanup'
end

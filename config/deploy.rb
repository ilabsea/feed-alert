# config valid only for current version of Capistrano
# sudo adduser ilab
# sudo adduser ilab sudo
# su ilab

#### with sudo task for deployment user -ie ilab 
#### sudo visudo and add this line ilab ALL=(ALL) NOPASSWD: ALL to skip password task
#### visudo will override .bashrc so better put rbenv init config in rbenv installation to .bash_profile instead of .bashrc


# sudo groupadd deployer
# sudo usermod -a -G deployer ilab
# sudo chown -R ilab:deployer /var/www
# sudo chmod -R g+w /var/www
# sudo chmod go-w -R /var/www warning “Insecure world writable dir /home/chance ” in PATH, mode 040777 http://stackoverflow.com/questions/5380671/getting-the-warning-insecure-world-writable-dir-home-chance-in-path-mode-04
# ssh config for remote server and repo

# env :PATH, ENV['PATH']

lock '3.3.5'

set :rbenv_ruby, File.read('.ruby-version').strip

set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :application, 'feed_alert'
set :repo_url, 'https://channainfo@bitbucket.org/ilab/feed-alert.git'
set :branch, :develop

# set :pty, true
# set :passenger_restart_with_sudo, false
# set :passenger_restart_command, "touch "
# set :passenger_restart_options, -> { "#{release_path.join('tmp/restart.txt')}" }

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end



#for sidekiq upstart

namespace :sidekiq do
  task :quiet do
    on roles(:app) do
      # Horrible hack to get PID without having to use terrible PID files
      puts "Killing sidekiq-upstart process "
      puts capture("kill -USR1 $(sudo initctl status sidekiq-upstart-main | grep /running | awk '{print $NF}') || :") 
      puts capture("sudo initctl stop sidekiq-upstart-main")

      puts capture("kill -USR1 $(sudo initctl status sidekiq-upstart-cron | grep /running | awk '{print $NF}') || :") 
      puts capture("sudo initctl stop sidekiq-upstart-cron")

    end
  end
  task :restart do
    on roles(:app) do
      # execute :sudo, :initctl, '--system' ,:restart, :'sidekiq-upstart'
      puts 'Restarting sidekiq-upstart-cron project'
      puts capture("sudo initctl start sidekiq-upstart-main")
      puts capture("sudo initctl start sidekiq-upstart-cron")
    end
  end
end

after 'deploy:starting', 'sidekiq:quiet'
after 'deploy:reverted', 'sidekiq:restart'
after 'deploy:published', 'sidekiq:restart'

# namespace :monit do
#   task :unmonitor do
#     on roles(:app) do
#       #execute :sudo, :monit, :unmonitor, :all
#       puts capture("sudo monit unmonitor all")
#     end
#   end
#   task :monitor do
#     on roles(:app) do
#       #execute :sudo, :monit, :monitor, :all
#       puts capture("sudo monit monitor all")
#     end
#   end
# end

# before 'deploy:starting', 'monit:unmonitor'
# after 'deploy:finished', 'monit:monitor'


# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, '/var/www/my_app_name'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, fetch(:linked_files, []).push('config/database.yml')
set :linked_files, %w{config/database.yml config/application.yml}

# Default value for linked_dirs is []
# set :linked_dirs, fetch(:linked_dirs, []).push('bin', 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system')

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5


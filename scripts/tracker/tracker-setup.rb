#!/usr/bin/env ruby

require_relative './base.rb'

class TrackerSetup < TrackerConfigurationBase
  include ProcessHelper

  def run
    # setup mysql
    process('brew link --force mysql@5.7')
    process('mysql.server start --skip-grant-tables')
    process("mysql -uroot -e \"UPDATE mysql.user SET authentication_string=PASSWORD('password') WHERE User='root'; FLUSH PRIVILEGES;\"")
    process('mysql.server stop')
    process('mkdir -p ~/Library/LaunchAgents')
    process('ln -sfv /usr/local/opt/mysql@5.7/*.plist ~/Library/LaunchAgents')
    process('launchctl load ~/Library/LaunchAgents/homebrew.mxcl.mysql@5.7.plist')

    # setup tracker-web
    FileUtils.cd("#{home}/workspace/tracker/apps/tracker-web") do
      process('rvm install $(cat .ruby-version)')
      process('rvm $(cat .ruby-version) do gem install bundler')
      process('rvm $(cat .ruby-version) do bundle install')
    end

    # Run direnv allow on all directories that require it.
    Dir.glob("#{home}/workspace/tracker/apps/tracker-web/**/.envrc").each do |envrc|
      FileUtils.cd(File.dirname(envrc)) do
        process('direnv allow')
      end
    end
  end
end

TrackerSetup.new.run

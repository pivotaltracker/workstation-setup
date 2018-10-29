#!/usr/bin/env ruby

require_relative './base.rb'

class TrackerSetup < TrackerConfigurationBase
  def run
    # setup Qt
    process_without_output('brew link --force qt@5.5')

    # setup mysql
    process_without_output('brew link --force mysql@5.7')
    process_without_output('brew services start mysql@5.7')

    # wait for mysql to start
    sleep(5) until mysql_running

    # Allow this to fail if there is a password already set.
    process_without_output('mysqladmin -u root password password', expected_exit_status: [0, 1])

    # Install Ruby
    ruby_version = process_without_output('cat ~/workspace/tracker/apps/tracker-web/.ruby-version')
    puts "Installing Ruby tools and Ruby #{ruby_version}"

    process_without_output('eval "$(rbenv init -)"')
    process_without_output("rbenv install --skip-existing #{ruby_version}")
    process_without_output("rbenv global #{ruby_version}")
    process_without_output('rbenv rehash')
    process_without_output('gem install bundler')

    # setup tracker-web
    FileUtils.cd("#{home}/workspace/tracker/apps/tracker-web") do
      process_without_output('bundle install')
    end

    # Run direnv allow on all directories that require it.
    Dir.glob("#{home}/workspace/tracker/apps/tracker-web/**/.envrc").each do |envrc|
      FileUtils.cd(File.dirname(envrc)) do
        process_without_output('direnv allow')
      end
    end

    # Install elm
    process_without_output('yarn global add elm@0.18.0')
    process_without_output('yarn global add elm-test@0.18.2')
    process_without_output('yarn global add elm-webpack-loader@4.3.1')
    process_without_output('yarn global add elm-hot-loader@0.5.4')
  end

  private

  def mysql_running
    output = process_with_output('pgrep mysql', expected_exit_status: [0, 1])
    !output.empty?
  end
end

TrackerSetup.new.run

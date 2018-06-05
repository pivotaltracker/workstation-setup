#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureBashTracker < TrackerConfigurationBase
  def run
    # Disable rbenv
    if process_exists?('rbenv')
      process_bash_it('disable plugin rbenv')
      process_without_output('brew unlink rbenv')
    end

    # Install RVM (receive the GPG key if necessary)
    unless process_exists?('rvm')
      if process_exists?('gpg')
        process_without_output('curl -o /tmp/mpapis.asc -#LO https://rvm.io/mpapis.asc')
        process_without_output('gpg --import /tmp/mpapis.asc')
      end
      process_without_output("\\curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles --with-gems='bundler rake'")
    end
    process_bash_it('enable plugin rvm')

    # Install brew Ruby and process_helper in the brew-installed version
    brew_install('ruby')
    process_without_output('gem install process_helper')

    # Install our .inputrc file
    FileUtils.copy("#{repo_root}/files/tracker/.inputrc", "#{home}/.inputrc")

    # Install bash_it configs
    FileUtils.cp_r("#{repo_root}/files/tracker/.bash_it/.", "#{home}/.bash_it", remove_destination: true)

    # Install our theme
    updated_bash_profile = File.new("#{home}/.new_bash_profile", 'wb')
    File.readlines("#{home}/.bash_profile").each do |line|
      if line =~ /^export BASH_IT_THEME=/
        updated_bash_profile << "export BASH_IT_THEME='bobby-tracker'\n"
      else
        updated_bash_profile << line
      end
    end
    updated_bash_profile.close
    FileUtils.move("#{home}/.new_bash_profile", "#{home}/.bash_profile")

    # Enable bash-it components
    process_bash_it('enable alias bundler')
    process_bash_it('enable completion git')
    process_bash_it('enable completion ssh')
    process_bash_it('enable plugin alias-completion')
    process_bash_it('enable plugin docker')
    process_bash_it('enable plugin ssh')
  end

  private

  def process_bash_it(command)
    process_without_output("bash -c \"source $HOME/.bash_profile && bash-it #{command}\"")
  end

  def process_exists?(process_name)
    !process_without_output("which #{process_name}", expected_exit_status: [0, 1]).empty?
  end
end

ConfigureBashTracker.new.run
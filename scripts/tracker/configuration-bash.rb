#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureBashTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    # Disable rbenv
    process_bash_it('disable plugin rbenv')
    process('brew unlink rbenv')

    # Install RVM (receive the GPG key if necessary)
    has_gpg = process('which gpg', expected_exit_status: [0, 1])
    unless has_gpg.empty?
      process('gpg --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3')
    end
    process("\\curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles --with-gems='bundler rake'")
    process_bash_it('enable plugin rvm')

    # Install brew Ruby and process_helper in the brew-installed version
    brew_install('ruby')
    process('gem install process_helper')

    # Install our .inputrc file
    FileUtils.copy("#{repo_root}/files/tracker/.inputrc", "#{home}/.inputrc")

    # Install our theme
    FileUtils.cp_r("#{repo_root}/files/tracker/.bash_it/themes/bobby-tracker", "#{home}/.bash_it/themes")
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

    # Install custom bash_it extensions
    FileUtils.cp_r("#{repo_root}/files/tracker/.bash_it/custom/.", "#{home}/.bash_it/custom", remove_destination: true)

    # Enable bash-it components
    process_bash_it('enable alias bundler')
    process_bash_it('enable completion git')
    process_bash_it('enable completion ssh')
    process_bash_it('enable plugin alias-completion')
    process_bash_it('enable plugin docker')
    process_bash_it('enable plugin ssh')
  end

  def process_bash_it(command)
    process("bash -c \"source $HOME/.bash_profile && bash-it #{command}\"")
  end
end

ConfigureBashTracker.new.run

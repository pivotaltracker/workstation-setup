#!/usr/bin/env ruby

require_relative './base.rb'

class ConfigureBashTracker < TrackerConfigurationBase
  include ProcessHelper

  def run
    # Disable rbenv
    process_bash_it('disable plugin rbenv')
    process('brew unlink rbenv')

    # Install RVM
    process("\curl -sSL https://get.rvm.io | bash -s stable --ignore-dotfiles --with-gems='bundler rake'")
    process_bash_it('enable plugin rvm')

    # Install our .inputrc file
    FileUtils.copy("#{repo_root}/files/tracker/.inputrc", "#{home}/.inputrc")

    # Install our theme
    FileUtils.cp_r("#{repo_root}/files/tracker/bobby-tracker", "#{home}/.bash_it/themes")
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
  end

  def process_bash_it(command)
    process("bash -c \"source $HOME/.bash_profile && bash-it #{command}\"")
  end
end

ConfigureBashTracker.new.run

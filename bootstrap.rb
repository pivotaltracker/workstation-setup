#!/usr/bin/env ruby

require 'stringio'
require 'open3'
require 'fileutils'
require 'timeout'

class BootstrapWorkstationSetup
  def run
    sudoers_admin_nopasswd
    install_command_line_tools
    clone_or_pull_repo
    bootstrap_process_helper
  end

  private

  def sudoers_admin_nopasswd
    process_lite(%q(sudo bash -c "echo '%admin		ALL = (ALL) NOPASSWD: ALL' > /etc/sudoers.d/admin_nopasswd"))
  end

  def bootstrap_process_helper
    need_to_install_in_system_ruby = false
    process_helper_gem_package_path = Dir.glob(File.join(repo_root, 'files/gems/process_helper-*.gem')).first
    cmd = "gem install #{process_helper_gem_package_path}"
    output, exitstatus = process_lite(cmd, raise_on_error: false)

    unless exitstatus == 0
      if output =~ /permission/i
        need_to_install_in_system_ruby = true
      else
        raise "Install of local process_helper gem package failed with exitstatus #{exitstatus}. " \
          " cmd: `#{cmd}`, output: #{output}"
      end
    end

    if need_to_install_in_system_ruby
      # system ruby detected, installing process_helper via sudo...
      # TODO: `unalias gem` MAY be needed, not sure yet
      process_lite("sudo gem install #{process_helper_gem_package_path}")
    end
  end

  def install_command_line_tools
    unless File.exist?('/Library/Developer/CommandLineTools')
      # fake that an install is in progress
      process_lite('touch /tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress')

      # list available software
      available_software, _ = process_lite("softwareupdate -l")

      # Get the last (should be latest version) entry for Command Line Tools
      software_name = available_software.split("\n")
        .reverse
        .detect {|line| line =~ /\* Command Line Tools/}
        .match(/.*?(Command Line Tools.*)$/)[1]

      # ...then install it
      process_lite("softwareupdate -i '#{software_name}' --verbose")
    end
  end

  def clone_or_pull_repo
    FileUtils.mkdir_p("#{home}/workspace")
    if File.exist?(repo_root)
      FileUtils.cd(repo_root) do
        verify_clean_git
        process_lite("git checkout master")
        process_lite("git pull --rebase")
      end
    else
      process_lite("git clone https://github.com/pivotaltracker/workstation-setup.git #{home}/workspace/workstation-setup")
    end
  end

  def verify_clean_git
    output, exit_status = process_lite("git status | grep -E '(to be committed|not staged|untracked)'", raise_on_error: false)
    if exit_status == 0
      # The exit status of the grep will be 0 only if one the repo is dirty.
      raise "\nERROR: There are uncommitted, unstaged or untracked git changes in #{repo_root}. " \
        "Please do a `git status` and resolve them, then start over.\nRepo state:\n#{output}"
    end
  end

  def home
    ENV.fetch('HOME')
  end

  def repo_root
    "#{home}/workspace/workstation-setup"
  end

  def process_lite(cmd, raise_on_error: true, log: true, timeout: 600)
    # A minimal implementation of what ProcessHelper does to use before it's installed
    puts cmd if log
    Open3.popen2e(cmd) do |_, stdout_and_stderr, wait_thr|
      exitstatus = nil
      begin
        Timeout.timeout(timeout) do
          exitstatus = wait_thr.value.exitstatus
        end
      rescue TimeoutError
        wait_thr.kill
        raise "Timeout trying to execute command: #{cmd}"
      end
      output = stdout_and_stderr.readlines.join
      raise output if exitstatus != 0 && raise_on_error
      return [output, exitstatus]
    end
  end
end

BootstrapWorkstationSetup.new.run

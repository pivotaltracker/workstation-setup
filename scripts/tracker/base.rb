require 'fileutils'
require 'process_helper'

class TrackerConfigurationBase
  include ProcessHelper
  def home
    ENV.fetch('HOME')
  end

  def repo_root
    "#{home}/workspace/workstation-setup"
  end

  def brew_install(app)
    process("brew install #{app}")
  end

  def brew_cask_install(app)
    process("brew cask install #{app}")
  end

  def process_without_output(command, opts = {})
    process(command, {puts_output: :error}.merge(opts))
  end
end

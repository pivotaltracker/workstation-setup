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

  def process_without_output(cmd, options = {})
    process(cmd, { out: :error, include_output_in_exception: false }.merge(default_options_for_process_helper).merge(options))
  end

  def process_with_output(cmd, options = {})
    process(cmd, default_options_for_process_helper.merge(options))
  end

  def default_options_for_process_helper
    # IMPORTANT NOTE: Running under a pseudo-terminal (pty) gives coloring and other
    # benefits, but will result in end-of-line being "\r\n" instead of just "\n".
    # Be aware of this if attempting to split return value into lines.
    { log: true, pty: false }
  end
end

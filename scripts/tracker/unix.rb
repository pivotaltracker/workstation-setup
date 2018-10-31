#!/usr/bin/env ruby

require_relative './base.rb'

class UnixTracker < TrackerConfigurationBase
  def run
    things = %w(
      ack
      awscli
      bash
      cloudfoundry/tap/cf-cli
      cmake
      coreutils
      ctags
      direnv
      ghostscript
      git
      git-duet/tap/git-duet
      glide
      gnupg
      go
      gradle
      haproxy
      htop
      httpie
      hub
      icu4c
      imagemagick
      ios-sim
      jmeter
      jq
      jsonpp
      lastpass-cli
      mas
      memcached
      mysql@5.7
      neovim
      nvm
      parallel
      proctools
      pstree
      python@2
      redis
      s3cmd
      shellcheck
      solr@6.6
      ssh-copy-id
      ripgrep
      tmux
      tree
      watch
      wget
      yarn
      zlib
    ).join(' ')

    process_without_output('brew tap pivotaltracker/homebrew-tracker')

    process_without_output("brew install #{things}")

    process_without_output("brew link --force solr@6.6")

    process_with_output('pip install virtualenv')

    # Copy .vimrc file
    FileUtils.copy("#{repo_root}/files/tracker/.vimrc", "#{home}/.vimrc")

    # Copy my.cnf file
    FileUtils.copy("#{repo_root}/files/mysql/my.cnf", "/usr/local/etc/my.cnf")

    # Install fly
    process_without_output("wget -O /usr/local/bin/fly 'https://cd.gcp.trackerred.com/api/v1/cli?arch=amd64&platform=darwin'")
    process_without_output('chmod +x /usr/local/bin/fly')
  end
end

UnixTracker.new.run

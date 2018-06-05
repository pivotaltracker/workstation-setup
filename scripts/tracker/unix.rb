#!/usr/bin/env ruby

require_relative './base.rb'

class UnixTracker < TrackerConfigurationBase
  def run
    things = %w(
      ack
      automake
      awscli
      bash
      carthage
      cloudfoundry/tap/cf-cli
      cmake
      coreutils
      ctags
      diff-so-fancy
      direnv
      dirmngr
      docbook-xsl
      ghostscript
      git
      git-duet/tap/git-duet
      glide
      gnupg
      go
      gpg-agent
      gradle
      haproxy
      htop
      httpie
      hub
      icu4c
      imagemagick
      ios-sim
      jid
      jmeter
      jq
      jsonpp
      lastpass-cli
      libusb-compat
      mas
      maven
      memcached
      mogenerator
      mysql@5.7
      neovim
      parallel
      phantomjs
      proctools
      pstree
      python@2
      qt@5.5
      redis
      s3cmd
      shellcheck
      solr@6.6
      ssh-copy-id
      sshuttle
      the_platinum_searcher
      ripgrep
      tig
      tmux
      tree
      vim
      watch
      wget
      yarn
      zlib
    )

    process_without_output('brew tap pivotaltracker/homebrew-tracker')

    things.each do |thing|
      brew_install(thing)
    end

    process_with_output('pip install virtualenv')

    # Copy .vimrc file
    FileUtils.copy("#{repo_root}/files/tracker/.vimrc", "#{home}/.vimrc")

    # Install fly
    process_without_output("wget -O /usr/local/bin/fly 'https://cd.gcp.trackerred.com/api/v1/cli?arch=amd64&platform=darwin'")
    process_without_output('chmod +x /usr/local/bin/fly')
  end
end

UnixTracker.new.run

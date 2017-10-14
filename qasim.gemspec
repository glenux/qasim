# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qasim/constants'

Gem::Specification.new do |spec|
  spec.name          = "qasim"
  spec.version       = if `git branch`.split($/).include?("* develop") then
						   Qasim::APP_VERSION + '.dev.' + Time.now.utc.strftime('%Y%m%d%H')
					   else
						   Qasim::APP_VERSION
					   end
  spec.authors       = ["Glenn Y. Rolland"]
  spec.email         = ["glenux@glenux.net"]
  spec.summary       = %q{Easy mount solution for SSH filesystems.}
  spec.description   = %q{Qasim is a front-end for sshfs, the filesystem
	client based on fuse and ssh. It provides automating and global settings
    control for sshfs mounts.}
  spec.homepage      = "http://glenux.github.io/qasim"
  spec.license       = "GPL-3"

  spec.files         = `git ls-files`.split($/)
  		.concat(Dir['*/**/*_ui.rb'])
		.concat(Dir['*/**/*_qrc.rb'])

  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.4.2"
  spec.add_development_dependency "minitest", "~> 5.7.0"
  spec.add_development_dependency "minitest-reporters"
  spec.add_development_dependency "pry", "~> 0.10.1"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-minitest"
  spec.add_development_dependency "rb-fsevent"
  spec.add_development_dependency "terminal-notifier-guard"


  #spec.add_runtime_dependency "qtbindings", "~> 4.8.6"
  spec.add_runtime_dependency "qml" 
  spec.add_runtime_dependency "thor", "~> 0.19.1"
end

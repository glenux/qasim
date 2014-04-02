# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'qasim/version'

Gem::Specification.new do |spec|
  spec.name          = "qasim"
  spec.version       = Qasim::APP_VERSION
  spec.authors       = ["Glenn Y. Rolland"]
  spec.email         = ["glenux@glenux.net"]
  spec.summary       = %q{Easy mount solution for SSH filesystems.}
  spec.description   = %q{Qasim is a front-end for sshfs, the filesystem
	client based on fuse and ssh. It provides automating and global settings
    control for sshfs mounts.}
  spec.homepage      = "http://glenux.github.io/qasim"
  spec.license       = "GPL-3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
end


# vim: set ts=2 sw=2 et:
require 'fileutils'
require 'qasim/map/generic'

class Qasim::Map::Webdav < Qasim::Map::Generic
  def initialize
  end

  def self.parameters
    super.merge({
      webdav_user:     { required: true}, # ex :           foo
      webdav_password: { required: true}, # ex :           bar
      webdav_port:     { default: 80},    # ex : 80, 8080, ...
      webdav_protocol: { default: :http}  # ex :   http, https
    })
  end

  def self.handles
    [ :webdav, :fusedav ]
  end
end


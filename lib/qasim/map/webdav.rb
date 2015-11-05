
# vim: set ts=2 sw=2 et:
require 'fileutils'
require 'qasim/map/generic'

module Qasim; module Map; class Webdav < Qasim::Map::Generic
  def initialize *opts
		super
  end

  def self.parameters
    super.merge({
      webdav_user:     { required: true}, # ex :           foo
      webdav_password: { required: true}, # ex :           bar
      webdav_port:     { default: 80},    # ex : 80, 8080, 443
      webdav_protocol: { default: :http}  # ex :   http, https
    })
  end

  def self.handles
    [ :webdav, :webdavs ]
  end
end ; end ; end




# vim: set ts=2 sw=2 et:
require 'fileutils'
require 'qasim/map/generic'

module Qasim; module Map; class Webdav < Qasim::Map::Generic
  def initialize *opts
		super
  end

  def self.parameters
    super.merge({
      smb_user:     { required: true}, # ex :           foo
      smb_password: { required: true}, # ex :           bar
    })
  end

  def self.handles
    [ :samba, :cifs, :smb ]
  end
end ; end ; end


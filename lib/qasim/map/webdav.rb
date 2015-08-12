
require 'fileutils'
require 'qasim/map/generic'

class Qasim::Map::Webdav < Qasim::Map::Generic
    def initialize
    end

    def self.parameters
      req = super
      req << :webdav_user     # ex: foo
      req << :webdav_password # ex: bar
      req << :webdav_port     # ex: 80, 8080, ...
      req << :webdav_protocol # ex: http, https
      req
    end

    def self.handles
      [ :webdav, :fusedav ]
    end
end


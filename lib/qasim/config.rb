
require 'optparse'
require 'ostruct'
require 'pp'
require 'find'

require 'qasim/map'
require 'qasim/map/ssh'

class Qasim::Config
	attr_reader :mount_dir
  attr_reader :config_dir
  attr_reader :debug
  attr_reader :verbose

	def initialize
		@mount_dir = File.join ENV['HOME'], 'mnt'

		@config_dir = Qasim::APP_CONFIG_DIR
		@config_file = nil
		@debug = false
		@verbose = false
	end
end


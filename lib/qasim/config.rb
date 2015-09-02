
require 'optparse'
require 'ostruct'
require 'pp'
require 'find'

require 'qasim/map'
require 'qasim/map/ssh'

class Qasim::Config
	attr_reader :mount_dir
  attr_reader :config_dir

	def initialize
		@mount_dir = File.join ENV['HOME'], 'mnt'

		@config_dir = Qasim::APP_CONFIG_DIR
		@config_file = nil
		@initialize_enable = false
		@umount_enable = false
		@target = nil
		@verbose_enable = false
		@debug = false
		@verbose = false
	end
end


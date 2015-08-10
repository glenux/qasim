
require 'optparse'
require 'ostruct'
require 'pp'
require 'find'

require 'qasim/map'
require 'qasim/map/ssh'

module Qasim
	class Config

		attr_reader :maps_active
		attr_reader :maps
		attr_reader :mnt_dir

		def initialize
			@mnt_dir = File.join ENV['HOME'], "mnt"

			@config_dir = APP_CONFIG_DIR
			@config_file = nil
			@maps = []
			@initialize_enable = false
			@umount_enable = false
			@target = nil
			@verbose_enable = false
			@debug = false
		end

		def parse_maps &blk
			@maps = []
			map_dirs = [@config_dir, APP_SYSCONFIG_DIR].select{ |d|
					File.exist? d and File.directory? d 
			}

			Find.find( *map_dirs ) do |path|
				# Skip unwanted files fast
				next unless File.file? path
				next unless File.basename( path ) =~ /.map$/

				begin
					map = Map::Ssh.new self, path
					yield map if block_given?
					maps.push map
				rescue
					raise RuntimeError, "Error while parsing map file"
				end
			end
		end

	end
end


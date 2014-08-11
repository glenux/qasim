
require 'optparse'
require 'ostruct'
require 'pp'
require 'find'

#require 'rdebug/base'
require 'qasim'

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
			#rdebug "Config: #{@config_dir}/config"

			@maps = []
			map_dirs = [@config_dir, APP_SYSCONFIG_DIR].select{ |d|
					File.exists? d and File.directory? d 
			}
			Find.find( *map_dirs ) do |path|
				if File.file? path
					if File.basename( path ) =~ /.map$/
						begin
							map = Map.new self, path
							yield map if block_given?
							maps.push map
						rescue
							# error while parsing map
						end
					end
					#total_size += FileTest.size(path)
				end
			end
		end

	end
end

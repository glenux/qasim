require 'thor'

module Qasim
	class Cli < Thor
		desc "init", "initialize user configuration"
		def init
			raise NotImplementedError
		end

		desc "list", "list"
		def list
			@config.maps.sort do |mx,my|
				mx.host <=> my.host
			end.each do |map|
				puts map.name
			end
		end

		desc "mount MAPS", "mount selected maps"
		def mount
			raise NotImplementedError
		end

		private
		#
		#
		#
		def initialize *opts
			super

			@all_maps = nil
			@active_maps = nil

			@config = Config.new
			@config.parse_maps
			#@config.parse_cmd_line ARGV

			@all_maps = {}
		end



		# create default map for each selected map
		# or default.map if none selected
		def run_init
		end

		def run_mount
			# asynchronous mount
			@config.maps.select do |map|
				pp map
				map.online?
				# if map.available? then
				#  map.connect!
				# end
			end
		end

		def run_umount
		end

		#
		#
		#
		def run
			case @config.action 
			when Config::ACTION_INIT
				run_init
			when Config::ACTION_MOUNT
				run_mount
			when Config::ACTION_UMOUNT
				run_umount
			else 
				raise RuntimeError, "Unknown action"
			end
		end

	end
end


require 'thor'
require 'pry'

module Qasim
	class Cli < Thor
    class_option :verbose, 
      type: :boolean,
      aliases: '-v'

		desc "init", "initialize user configuration"
		def init
			raise NotImplementedError
		end


    option :describe, 
      type: :boolean,
      aliases: '-d'
		desc "list", "list"
		def list
			@map_manager.sort do |mx,my|
				mx.host <=> my.host
			end.each do |map|
				puts map.name
        if options[:describe] then
          map.links.each do |link,where|
            puts "  -    link: " + link
            puts "         to: " + where
            puts "    mounted: " + map.mounted?
          end
        end
			end
		end

    desc "add MAP", "add a new map"
    def add map_name
			res = @config.maps.select do |map|
        map.name == map_name
			end
      pp res
      if not res.empty? then
        puts "ERROR: name #{map_name} already exist !"
        exit 1
      end
    end

    desc "del MAP", "delete selected map"
    def del map_name
			res = @config.maps.select do |map|
        map.name == map_name
			end
      pp res.first.filename
    end

		desc "mount MAPS", "mount selected maps"
		def mount
      Map.select name: map_name
			raise NotImplementedError
		end

		private
		#
		#
		#
		def initialize *opts
			super
			@active_maps = nil
			@config = Config.new
			@map_manager = MapManager.new @config
      @map_manager.parse_maps
		end


		# create default map for each selected map
		# or default.map if none selected
		def run_init
		end

		def run_mount
			# asynchronous mount
			@map_manager.select do |map|
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


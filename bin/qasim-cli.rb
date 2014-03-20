#!/usr/bin/ruby

$DEBUG = true
$VERBOSE = true

require 'pp'
require 'qasim'

module Qasim

	class QasimCli
		#
		#
		#
		def initialize
			@all_maps = nil
			@active_maps = nil

			puts "-- sshfs-mapper --"
			@config = Config.new
			@config.parse_cmd_line ARGV
			@config.parse_file

			@all_maps = {}
			pp @config
		end


		# create default map for each selected map
		# or default.map if none selected
		def run_init
		end

		def run_mount

			# asynchronous mount
			selected_maps = @config.maps.select do |map|
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

			puts "--run"
		end

	end
end

app = Qasim::Qasim.new
app.run



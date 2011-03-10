#!/usr/bin/ruby
# vim: set ts=2 sw=2 :

$DEBUG = true
$VERBOSE = true

require 'pp'
require 'sshfs-mapper/config'
require 'sshfs-mapper/map'

module SshfsMapper

	class SshfsMapper 
		#
		#
		#
		def initialize
			@all_maps = nil
			@active_maps = nil

			puts "-- sshfs-mapper --"
			conf = Config.new
			conf.parse_cmd_line ARGV
			@all_maps = conf.parse_file
			puts conf
		end


		# create default map for each selected map
		# or default.map if none selected
		def run_init
		end

		def run_mount

			selected_maps = if @config.all_maps @all_maps

			@all_maps.each do |map|
				pp map
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

app = SshfsMapper::SshfsMapper.new
app.run



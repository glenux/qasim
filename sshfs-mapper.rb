#!/usr/bin/ruby
# vim: set ts=2 sw=2 :

$DEBUG = true
$VERBOSE = true

require 'sshfs-mapper/config'
require 'sshfs-mapper/map'

module SshfsMapper
	class SshfsMapper 
		def initialize
			@active_maps = nil
			puts "-- sshfs-mapper --"
			conf = Config.new
			conf.parse_cmd_line ARGV
			@active_maps = conf.parse_file
			puts conf
		end


		def run
			if @active_maps.nil? then
				return
			end
			@active_maps.each do |map|
				map.connect()
			end
			puts "--run"
		end

	end
end

app = SshfsMapper::SshfsMapper.new
app.run



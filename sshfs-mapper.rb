#!/usr/bin/ruby

require 'config'
require 'map'

module SshfsMapper
	class SshfsMapper 
		def initialize()
			@maps = nil
			puts "-- sshfs-mapper --"
			conf = Config.new
			conf.parseCmd ARGV
			@maps = conf.parseFile
			puts conf
		end


		def run()
			if @maps.nil? then
				return
			end
			@maps.each do |map_path|
				map = Map.new( map_path )
			end
			puts "--run"
		end

	end
end

app = SshfsMapper::SshfsMapper.new
app.run


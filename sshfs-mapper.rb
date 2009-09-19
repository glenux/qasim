#!/usr/bin/ruby
# vim: set ts=2 sw=2 :

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
			@maps.each do |map|
				map.connect()
			end
			puts "--run"
		end

	end
end

app = SshfsMapper::SshfsMapper.new
app.run


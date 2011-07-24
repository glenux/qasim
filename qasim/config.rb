#!/usr/bin/ruby
# vim: set ts=4 sw=4:

require 'optparse'
require 'ostruct'
require 'pp'
require 'find'

require 'rubygems'
require 'rdebug/base'
require 'qasim/map'

module Qasim
	class Config

		attr_reader :maps_active
		attr_reader :maps
		attr_reader :mnt_dir

		def initialize

			user = if ENV['USER'] then
					   ENV['USER']
				   else
					   raise "Environment variable 'USER' is missing!"
				   end

			home_dir = if ENV['HOME'] then 
						   ENV['HOME']
					   else
						   "/home/" + user
					   end

			xdg_dir = if ENV['XDG_CONFIG_HOME'] then
						  ENV['XDG_CONFIG_HOME']
					  else
						  home_dir + '/.config'
					  end

			@mnt_dir = File.join home_dir, "mnt"

			@config_dir = xdg_dir + '/sshfs-mapper'
			@config_file = nil
			@maps = []
			@initialize_enable = false
			@umount_enable = false
			@target = nil
			@verbose_enable = false
			@debug = false
		end

		def parse_maps &blk
			rdebug "Config: #{@config_dir}/config"

			@maps = []
			Find.find( @config_dir ) do |path|
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

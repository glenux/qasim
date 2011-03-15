#!/usr/bin/ruby
# vim: set ts=4 sw=4:

require 'optparse'
require 'ostruct'
require 'pp'
require 'find'

require 'rubygems'
require 'rdebug/base'

module SshfsMapper
	class Config

		attr_reader :maps_active
		attr_reader :maps
		attr_reader :action

		ACTION_UMOUNT = :umount
		ACTION_MOUNT = :mount
		ACTION_INIT = :init

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

			@action = ACTION_MOUNT
			@config_dir = xdg_dir + '/sshfs-mapper'
			@config_file = nil
			@maps = []
			@initialize_enable = false
			@umount_enable = false
			@target = nil
			@verbose_enable = false
			@debug = false
		end

		def parse_file &blk
			rdebug "Config: #{@config_dir}/config"

			@maps = []
			Find.find( @config_dir ) do |path|
				if File.file? path
					if File.basename( path ) =~ /.map$/
						begin
							map = Map.new path
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

		def parse_cmd_line args
			opts = OptionParser.new do |opts|

				opts.banner = "Usage: #{$0} [action] [options]"

				opts.separator ""
				opts.separator "Action (mount by default):"

				opts.on('-u', '--umount', 'Umount') do |umount|
					@action = ACTION_UMOUNT
				end

				opts.on('-i', '--initialize', 'Populate with default configuration' ) do |init|
					@action = ACTION_INIT
				end

				opts.separator "Specific options:"

				opts.on('-a', '--all', 'Targets all enabled maps (disables -s)') do |all|
					@targets_all = all
				end

				#FIXME: use target list there
				opts.on('-s', '--select TARGET', 'Target selected map (even disabled)') do |target|
					@targets << target
				end

				opts.on('-v', '--[no-]verbose', 'Run verbosely' )  do |verbose|
					@verbose_enable = verbose
				end
			end

			begin
				opts.parse! args
			rescue OptionParser::ParseError => e
				puts opts.to_s
				puts ""
				puts e.message
				exit 1
			end
		end

		def to_s
			s = []
			s << "config_file = #{@config_file}"
			s << "verbose_enable = #{@verbose_enable}"
			s.join "\n"
		end
	end
end

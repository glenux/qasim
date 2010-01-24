#!/usr/bin/ruby
# vim: set ts=4 sw=4:

require 'optparse'
require 'ostruct'
require 'pp'
require 'find'

module SshfsMapper
	class Config
		attr_reader :maps_active
		attr_reader :maps

		def initialize()
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

			@config_dir = xdg_dir + '/sshfs-mapper'
			@maps = []
			@initialize_enable = false
			@umount_enable = false
			@target = nil
			@verbose_enable = false
		end

		def parseFile( &blk )
			puts "Config: #{@config_dir}/config"

			maps = []
			Find.find( @config_dir ) do |path|
				if File.file?( path )
					if File.basename( path ) =~ /.map$/
						begin
							map = Map.new( path )
							map.parse()
							if blk then 
								yield map 
							else 
								maps.push( map )
							end
						rescue
							# error while parsing map
						end
					end
					#total_size += FileTest.size(path)
				end
			end
			return maps
		end

		def parseCmd( args )
			opts = OptionParser.new do |opts|

				opts.banner = "Usage: #{$0} [options]"

				opts.separator ""
				opts.separator "Specific options:"

				opts.on('-a', '--all', 'Mount all targets (disables -s)') do |all|
					@all_enable = all
				end

				#FIXME: use target list there
				opts.on('-s', '--select TARGET', 'Mount only specified target') do |target|
					@targets << target
				end

				opts.on('-u', '--umount', 'Umount') do |umount|
					@umount_enable = umount
				end

				opts.on('-i', '--initialize',
						'Populate default configuration and example map' )  do |init|
					@initialize_enable = init
						end

				opts.on('-v', '--[no-]verbose', 'Run verbosely' )  do |verbose|
					@verbose_enable = verbose
				end
			end

			begin
				opts.parse!( args )
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
			s.join("\n")
		end
	end
end

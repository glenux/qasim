#!/usr/bin/ruby

require 'optparse'
require 'ostruct'
require 'pp'
require 'find'

class Config
	attr_reader :options

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

		@options = OpenStruct.new( {
			:config_dir => xdg_dir + '/sshfs-mapper',
			:map_list => [],
			:initialize_enable => false,
			:umount_enable => false,
			:target => nil,
			:verbose_enable => false
		} )
	end

	def parseFile
		puts "Parsing #{@options.config_dir}/config"
		puts "Parsing maps..."

		Find.find( @options.config_dir ) do |path|
			if File.file?( path )
				if File.basename( path ) =~ /.map$/
					puts "* #{File.basename( path )}"
				else
					Find.prune       # Don't look any further into this way
				end
				#total_size += FileTest.size(path)
			end
		end

	end

	def parseCmd( args )
		opts = OptionParser.new do |opts|

			opts.banner = "Usage: #{$0} [options]"

			opts.separator ""
			opts.separator "Specific options:"

			opts.on('-t', '--target TARGET', 'Mount only specified target') do |target|
				@options.resize_enable = true
				@options.resize_width = resizeX.to_i
				@options.resize_height = resizeY.to_i
			end

			opts.on('-u', '--umount', 'Umount') do |umount|
				@options.umount_enable = umount
			end

			opts.on('-i', '--initialize',
					'Populate default configuration and example map' )  do |init|
				@options.initialize_enable = init
					end

			opts.on('-v', '--[no-]verbose', 'Run verbosely' )  do |verbose|
				@options.verbose_enable = verbose
			end
		end

		begin
			opts.parse!( args )
		rescue OptionParser::ParseError => e
			puts e.message
			exit 1
		end
		@options
	end

	def to_s
		s = []
		s << "config_file = #{@options.config_file}"
		s << "verbose_enable = #{@options.verbose_enable}"
		s.join("\n")
	end
end


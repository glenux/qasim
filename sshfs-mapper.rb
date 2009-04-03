#!/usr/bin/ruby

require 'config'

class Map 
	def initialize() 
	end

	def self.loadFromFile( filename ) 
	end


end

class Config 

end


class SshfsMapper 
	def initialize()
		puts "-- sshfs-mapper --"
		conf = Config.new
		conf.parseCmd ARGV
		conf.parseFile
		puts conf
	end

end


SshfsMapper.new


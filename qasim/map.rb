
require 'rubygems'
require 'rdebug/base'

module Qasim

	class Map 
		attr_reader :path,
		   	:host, 
			:port, 
			:enable, 
			:user, 
			:map

		class MapParseError < RuntimeError
		end

		CYPHER_ARCFOUR = :arcfour
		CYPHER_AES256CBC = "aes-256-cbc".to_sym
		CYPHERS = [ CYPHER_ARCFOUR, CYPHER_AES256CBC ]


		def initialize map_path
			@path = map_path
			@host = nil
			@port = 22
			@enable = false
			@user = nil
			@cypher = :arcfour
			@maps = {}
			@debug = true

			self.load @path
		end

		def load path=nil
			@path=path unless path.nil?
			rdebug "Parsing map #{@path}"
			f = File.open @path
			linect = 0
			local_env = ENV.clone
			f.each do |line|
				line = line.strip
				linect += 1

				while line =~ /\$(.*)/ do
					pattern = $1
					puts "FOUND PATTERN %s => %s" % [$1, local_env[$1]]
					line.gsub!(/\$#{pattern}/,local_env[$1])
					line.gsub!(/\$\{#{pattern}\}/,local_env[$1])
				end

				case line
				when /^\s*REMOTE_USER\s*=\s*(.*)\s*$/ then
					@user = $1
					rdebug "d: remote_user => #{$1}"
				when /^\s*REMOTE_PORT\s*=\s*(.*)\s*$/ then
					@port = $1.to_i
					rdebug "d: remote_port => #{$1}"
				when /^\s*REMOTE_HOST\s*=\s*(.*)\s*$/ then
					@host = $1
					rdebug "d: remote_host => #{$1}"
				when /^\s*REMOTE_CYPHER\s*=\s*(.*)\s*$/ then
					if CYPHERS.map{|x| x.to_s}.include? $1 then
						@host = $1.to_sym
					end
				when /^\s*MAP\s*=\s*(.*)\s+(.*)\s*$/ then
					@maps[$1] = $2
					rdebug "d: map #{$1} => #{$2}"
				when /^\s*$/,/^\s*#/ then
					rdebug "d: dropping empty line"
				else
					raise MapParseError, "parse error at #{@path}:#{linect}"
				end
			end
			f.close
		end

		def write path=nil
			@path=path unless path.nil?

			File.open(@path, "w") do |f|
				f.puts "REMOTE_USER=%s" % @user
				f.puts "REMOTE_PORT=%s" % @port
				f.puts "REMOTE_HOST=%s" % @host
				f.puts "REMOTE_CYPHER=%s" % @cypher
			end
		end

		def online?
			rdebug  "testing online? %s " % self.inspect
			#FIXME: test liveness
		end

		def connected? 
			#FIXME test if connected / mounted
		end

		def connect
			puts "[#{File.basename @path}] Connecting..."
			puts "  #{@user}@#{@host}:#{@port}"
			puts "  maps = %s" % @maps.map{ |k,v| "%s => %s" % [ k, v ] }.join(', ')
			# do something
			# test server connection
			# mount
		end

		def disconnect
			puts "Disconnecting map #{@path}"
			# umount	
		end
	end
end
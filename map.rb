module SshfsMapper

	class Map 
		attr_reader :path, :host, :port, :user, :map
		@@debug = false

		class MapParseError < RuntimeError
		end

		def initialize( map_path )
			@path = map_path
			@host = nil
			@port = 22
			@user = nil
			@engine = :arcfour
			@maps = {}
		end

		def parse
			puts "Parsing map #{@path}"
			f = File.open( @path )
			linect = 0
			f.each do |line|
				line = line.strip
				linect += 1

				#puts "  [#{line}]"
				case line
				when /^\s*REMOTE_USER\s*=\s*(.*)\s*$/ then
					@user = $1
					puts "d: remote_user => #{$1}" if @@debug
				when /^\s*REMOTE_PORT\s*=\s*(.*)\s*$/ then
					@port = $1.to_i
					puts "d: remote_port => #{$1}" if @@debug
				when /^\s*REMOTE_HOST\s*=\s*(.*)\s*$/ then
					@host = $1
					puts "d: remote_host => #{$1}" if @@debug
				when /^\s*REMOTE_CYPHER\s*=\s*(.*)\s*$/ then
					cyphers = ["arcfour", "aes-256-cbc"]
					if cyphers.include? $1 then
						@host = $1
					end
				when /^\s*MAP\s*=\s*(.*)\s+(.*)\s*$/ then
					@maps[$1] = $2
					puts "d: map #{$1} => #{$2}" if @@debug
				when /^\s*$/ then
					puts "d: dropping empty line" if @@debug
				else
					raise MapParseError, "parse error at #{@path}:#{linect}"
				end
			end
			f.close
			#
		end

		def is_alive?
			#FIXME: test liveness
		end

		def is_connected? 
			#FIXME test if connected / mounted
		end

		def connect() 
			puts "[#{File.basename @path}] Connecting..."
			puts "  #{@user}@#{@host}:#{@port}"
			puts "  maps = #{@maps}"
			# do something
			# test server connection
			# mount
		end

		def disconnect()
			puts "Disconnecting map #{@path}"
			# umount	
		end
	end
end

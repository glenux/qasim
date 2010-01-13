module SshfsMapper
	class Map 
		attr_reader :path, :host, :port, :user, :map

		def initialize( map_path )
			@path = map_path
			@host = nil
			@port = 22
			@user = nil
			@engine = :arcfour
			@maps = {}
		end

		def parse()
			puts "Parsing map #{@path}"
			f = File.open( @path )
			f.each do |line|
				case line
				when /^\s*REMOTE_USER\s*=\s*(.*)\s*$/
					@user = $1
				when /^\s*REMOTE_PORT\s*=\s*(.*)\s*$/
					@port = $1.to_i
				when /^\s*REMOTE_HOST\s*=\s*(.*)\s*$/
					@host = $1
				when /^\s*REMOTE_CYPHER\s*=\s*(.*)\s*$/
					idx = ["arcfour", "aes-256-cbc"].index( $1 )
					if not idx.nil? then
						@host = $1
					end
				when /^\s*MAP\s*=\s*(.*)\s+(.*)\s*$/
					@maps[$1] = $2
				else
					puts "dropping #{line}"
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

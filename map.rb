module SshfsMapper
	class Map 
		attr_reader :path, :host, :port, :user, :map

		def initialize( map_path )
			@path = map_path
			@host = nil
			@port = 22
			@user = nil
			@map = {}
		end

		def parse()
			puts "Parsing map #{@path}"
			File.open( @path ) do |f|
				f.each do |line|
					case line 
					when /^MAP\s*=\s*(\S+)\s*(\S+)\s*$/ then
						@map[$1] = $2
					when /^REMOTE_HOST\s*=\s*(\S+)\s*$/ then
						@host = $1
					when /^REMOTE_PORT\s*=\s*(\S+)\s*$/ then
						@port = $1
					when /^REMOTE_USER\s*=\s*(\S+)\s*$/ then
						@user = $1
					when /^\s*$/ then
						# skip
					else
						puts "unexpectd line '#{line}'"
					end
				end
			end
		end

		def is_alive?
			#FIXME: test liveness
		end

		def is_connected? 
			#FIXME test if connected / mounted
		end

		def connect() 
			puts "Connecting map #{@path}"
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

module SshfsMapper
	class Map 
		def initialize( map_path )
			@path = map_path
			@host = nil
			@port = 22
			@user = nil
		end

		def parse()
			puts "Parsing map #{@path}"
			#
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

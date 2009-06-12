module SshfsMapper
	class Map 
		def initialize( map_path )
			@path = map_path
			@host = nil
			@port = 22
			@user = nil
		end

		def parse()
			puts "Parsing #{@path}"
		end
	end
end

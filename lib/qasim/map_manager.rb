
class Qasim::MapManager
  # FIXME: move out of config
	def initialize config
    @maps = []
    @config = config
    puts "MapManager::initialize"
  end
  
  def sort &blk
    @maps.sort &blk
  end

  def select &blk
    @maps.select &blk
  end

  def each &blk
    @maps.each &blk
  end

  def parse_maps &blk
		@maps = []
		map_dirs = [@config.config_dir, Qasim::APP_SYSCONFIG_DIR].select{ |d|
			File.exist? d and File.directory? d 
		}

		Find.find(*map_dirs) do |path|
			# Skip unwanted files fast
			next unless File.file? path
			next unless File.basename(path) =~ /.map$/

			begin
				map = Qasim::Map.from_file self, path
				yield map if block_given?
				@maps.push map
			rescue Qasim::Map::ParseError
				raise RuntimeError, "Error while parsing map file"
			end
		end
	end
end

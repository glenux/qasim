require 'fileutils'

module Qasim ; module Map
end ; end

class Qasim::Map::Generic
  def initialize app_config, params
    @app_config = app_config
    #@params = params # FIXME: ?

    @links = params[:links]
		params.delete :links

		@filename = params[:filename] 
		params.delete :filename

		@name = File.basename @filename, '.map'
  end


  # Return a list of options for this map type
  #
  # Format :
  # Hash of (name:Symbol * [value:Object, optional:Boolean])
  

  def self.parameters
    {
      map_name:       [nil , true],
      map_enable:     [true, false],
      map_mountpoint: [nil, true]
    }
  end

  #
  # Test map liveness (connected & working)
  #
  def alive?
  end

  #
  # Test map 
  #
  def mounted?
  end

  #
  # Mount
  #
  def mount
  end

  # 
  # Umount
  #
  def umount
  end

end

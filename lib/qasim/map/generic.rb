require 'fileutils'

module Qasim ; module Map
end ; end

class Qasim::Map::Generic
  attr_reader :links
  attr_reader :filename
  attr_reader :name

  def initialize app_config, params
    @app_config = app_config

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
  # MUST BE IMPLEMENTED BY SUBCLASSES
  #
  def alive?
    raise NotImplementedError
  end

  #
  # Test map 
  #
  # MUST BE IMPLEMENTED BY SUBCLASSES
  #
  def mounted?
    raise NotImplementedError
  end

  #
  # Mount
  #
  # MUST BE IMPLEMENTED BY SUBCLASSES
  #
  def mount
    raise NotImplementedError
  end

  # 
  # Umount
  #
  # MUST BE IMPLEMENTED BY SUBCLASSES
  #
  def umount
    raise NotImplementedError
  end
end


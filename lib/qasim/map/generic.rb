require 'fileutils'

module Qasim ; module Map
end ; end

class Qasim::Map::Generic
  def initialize params
  end


  # Return a list of options for this map type
  #
  # Format :
  # Hash of (name:Symbol * [value:Object, optional:Boolean])
  

  def self.parameters
    {
      map_name:       [nil , true],
      map_enabled:    [true, false],
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

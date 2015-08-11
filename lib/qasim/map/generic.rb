require 'fileutils'
require 'qasim/map'

module Qasim ; module Map
end ; end

class Qasim::Map::Generic
  def initialize config
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

end


require 'qasim/constants'

def _ str
	Qt::Object.tr(str)
end


## Core libs
require 'qasim/constants'
require 'qasim/config'
require 'qasim/map'
require 'qasim/map_manager'

## Plugins for maps
require 'qasim/map/generic'
require 'qasim/map/smb'
require 'qasim/map/ssh'
require 'qasim/map/webdav'




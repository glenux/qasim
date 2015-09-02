
require 'qasim/constants'

def _ str
	Qt::Object.tr(str)
end

module Qasim
	autoload :Config,     'qasim/config'
	autoload :Map,        'qasim/map'
	autoload :Ui,         'qasim/ui'
	autoload :Cli,        'qasim/cli'
  autoload :MapManager, 'qasim/map_manager'
end



require 'qasim/ui/about_ui'

module Qasim ; module Ui
	class About < Qt::Dialog
		def initialize
			super
			u = Ui_About.new                                                                                                    
			u.setup_ui(self)

			#FIXME: attach events to close
			#FIXME: set first tab
		end
	end
end ; end

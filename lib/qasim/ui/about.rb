
require 'qasim/ui/about_ui'

module Qasim ; module Ui
	class About < Qt::Dialog
		def initialize
			u = Ui_About.new                                                                                                    
			u.setup_ui(self)
		end
	end

end ; end

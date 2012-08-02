
require 'qasim/ui/preferences_ui'

module Qasim ; module Ui
	class Preferences < Qt::Dialog
		def initialize(parent = nil)
			super
			@ui = Ui_Preferences.new                                                                                                    
			@ui.setup_ui(self)
		end
	end
end ; end

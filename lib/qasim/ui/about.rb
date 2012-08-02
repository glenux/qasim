
require 'qasim/ui/about_ui'

module Qasim ; module Ui
	class About < Qt::Dialog
		def initialize
			super
			u = Ui_About.new                                                                                                    
			u.setup_ui(self)

			#FIXME: attach button events to dialog.close
			
			# Change title according to current version
			title_str = "Qasim v%s (%s)" % [ Qasim::APP_VERSION, Qasim::APP_DATE ]
			u.title_label.text = Qt::Application.translate(
				"About", 
				"<html><head/><body><p><span style=\" font-size:11pt; font-weight:600;\">#{title_str}" +
				"</span></p></body></html>", 
				nil, 
				Qt::Application::UnicodeUTF8
			)

			#FIXME: set first tab
		end
	end
end ; end

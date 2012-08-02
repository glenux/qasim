
require 'qasim/ui/about_ui'

module Qasim ; module Ui
	class About < Qt::Dialog
		def initialize(parent = nil)
			super
			@ui = Ui_About.new                                                                                                    
			@ui.setup_ui(self)

			#FIXME: attach button events to dialog.close
			#Qt::Object.connect( w, SIGNAL( :clicked ), a, SLOT( :quit ) )
			
			# Change title according to current version
			title_str = "Qasim v%s (%s)" % [ Qasim::APP_VERSION, Qasim::APP_DATE ]
			@ui.title_label.text = Qt::Application.translate(
				"About", 
				title_str, 
				nil, 
				Qt::Application::UnicodeUTF8
			)

			# Read Authors
			file = Qt::File.new(':/qasim/authors') 
			if file.open(Qt::File::ReadOnly | Qt::File::Text)
				stream = Qt::TextStream.new( file )
				@ui.authors_textedit.text = stream.readAll()	
				file.close
			else
				# FIXME handle error on authors reading
			end

			# Read Thanks
			file = Qt::File.new(':/qasim/thanks') 
			if file.open(Qt::File::ReadOnly | Qt::File::Text)
				stream = Qt::TextStream.new( file )
				@ui.thanks_textedit.text = stream.readAll()	
				file.close
			else
				# FIXME handle error on thanks reading
			end

			# Read License
			file = Qt::File.new(':/qasim/licence-gpl3') 
			if file.open(Qt::File::ReadOnly | Qt::File::Text)
				stream = Qt::TextStream.new( file )
				@ui.license_textedit.text = stream.readAll()	
				file.close
			else
				# FIXME handle error on licence reading
			end

			#FIXME: set first tab
		end
	end
end ; end

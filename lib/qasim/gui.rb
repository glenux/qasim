require 'qasim/qasim_qrc'
require 'qasim/ui'

module Qasim
	class QasimApp ; end

	class QasimGui < QasimApp

		class LockError < RuntimeError ; end

		def initialize
			@config = Config.new
      @map_manager = MapManager.new @config

			@map_menu = nil
			@context_menu = nil
			@connect_error = {}
			@connect_running = {}
		end

		def dbus_notify title, body, icon
			bus = Qt::DBusConnection.sessionBus
			if !bus.connected?
				$stderr.puts(
          			"Cannot connect to the D-BUS session bus.\n" \
					"To start it, run:\n" \
					"\teval `dbus-launch --auto-syntax`\n"
        		)
				exit 1
			end
			msg = Qt::DBusMessage.create_method_call(
        		'org.freedesktop.Notifications',
				'/org/freedesktop/Notifications',
				'org.freedesktop.Notifications',
				'Notify' 
      		)
			msg.arguments = [ APP_NAME, Qt::Variant.from_value( 0, "unsigned int" ),
				     icon, title, body, [], {}, -1  ]
			_rep = bus.call( msg )
			#	if rep.type == Qt::DBusMessage

			#		si.showMessage("Qasim", 
			#					   "Sorry dude", 2, 5000 )
		end


		#
		# Rebuild map menu
		#
		def build_map_menu
			# reload maps dynamically
			@map_manager.parse_maps
			@map_menu ||= Qt::Menu.new
			@map_menu.clear

			previous_host = nil
			@map_manager.sort do |mx,my|
				mx.name <=> my.name
			end.each do |map|
				#if map.host != previous_host and not previous_host.nil? then
				#	@map_menu.addSeparator
				#end
				itemx = Qt::Action.new(map.name, @map_menu)
				itemx.setCheckable true;
        
        #puts "Loading #{map.inspect}"
				if map.mounted? then
					itemx.setChecked true
				end
				itemx.connect(SIGNAL(:triggered)) do 
					action_trigger_map_item map, itemx
				end
				@map_menu.addAction itemx;
				#previous_host = map.name
			end
		end

		#
		# Action when map item triggered
		#
		def action_trigger_map_item map, item
			@connect_error[map.filename] = Set.new
			@connect_running[map.filename] = 0
			method = if map.mounted? then :umount
					 else :mount
					 end

			begin
				map.send(method) do |linkname,cmd,cmd_args|
					process = Qt::Process.new
					process.connect(SIGNAL('finished(int, QProcess::ExitStatus)')) do |exitcode,exitstatus|
						#puts "exitcode = %s, exitstatus = %s" % [exitcode, exitstatus]
						@connect_running[map.filename] -= 1 
						if exitcode != 0 then
							@connect_error[map.filename].add linkname
						else
						end
						if @connect_running[map.filename] == 0 then
							# display someting
							if @connect_error[map.filename].empty? then

								dbus_notify "%s (%s)" % [APP_NAME, map.name], 
									("<b>Map %sed successfully<b>" % method.to_s), 
									'dialog-information'
							else
								erroneous = @connect_error[map.path].to_a.join(', ')
								dbus_notify "%s (%s)" % [APP_NAME, map.name], 
									("<b>Unable to %s map</b><br>" % method.to_s) +
									("Broken link(s): %s" % erroneous), 
									'dialog-error'
							end
						end
					end
					@connect_running[map.path] += 1
					process.start cmd, cmd_args
				end

			rescue Map::ConnectError => e
				puts e.inspect
			end
		end

		#
		#
		#
		def build_context_menu
			@context_menu = Qt::Menu.new

			act_pref = Qt::Action.new _('&Preferences'), @context_menu
			act_pref.setIcon(  Qt::Icon::fromTheme("configure") ) rescue nil
			act_pref.setIconVisibleInMenu true
			act_pref.setEnabled false
			act_pref.connect(SIGNAL(:triggered)) do 
				_res = @pref_dialog.show
			end
			@context_menu.addAction act_pref;

			act_about = Qt::Action.new '&About', @context_menu
			act_about.setIcon( Qt::Icon::fromTheme("help-about") ) rescue nil
			act_about.setIconVisibleInMenu true
			#act_about.setEnabled true
			act_about.connect(SIGNAL(:triggered)) do 
				_res = @about_dialog.show
			end
			@context_menu.addAction act_about;

			@context_menu.addSeparator

			act_quit = Qt::Action.new _('Quit'), @context_menu
			act_quit.setIcon(  Qt::Icon::fromTheme("application-exit") ) rescue nil
			act_quit.setIconVisibleInMenu true
			act_quit.connect(SIGNAL(:triggered)) { @app.quit }
			@context_menu.addAction act_quit
		end


		#
		#
		#
		def build_interface

			@app = Qt::Application.new(ARGV)
			#Qt.debug_level = Qt::DebugLevel::High
			#Qt.debug_level = Qt::DebugLevel::Extensive
			@app.setQuitOnLastWindowClosed false

			@main_win = Qt::MainWindow.new
			@systray  = Qt::SystemTrayIcon.new @main_win
			@about_dialog = Qasim::Ui::About.new @main_win
			@pref_dialog = Qasim::Ui::Preferences.new @main_win

			std_icon = Qt::Icon.new( ":/qasim/qasim-icon" )
			_alt_icon = Qt::Icon.new
			_blinking = false

			@systray.icon  = std_icon
			@systray.show


			@systray.setToolTip("Qasim %s" % APP_VERSION);

			build_map_menu
			build_context_menu

			@systray.contextMenu = @context_menu

			@systray.connect(SIGNAL('activated(QSystemTrayIcon::ActivationReason)')) do |reason|
				case reason
				when Qt::SystemTrayIcon::Trigger then
					build_map_menu
					@map_menu.popup(Qt::Cursor::pos())
					#blinking = !blinking
					#si.icon  = blinking ? alt_icon : std_icon
				when Qt::SystemTrayIcon::MiddleClick then
					#
				when Qt::SystemTrayIcon::Context then
					#
				when Qt::SystemTrayIcon::DoubleClick then
					#
				end
			end
		end


		def lock_set
			begin
				# create an exclusive lock file
				_have_lock = true

				FileUtils.mkdir_p APP_CONFIG_DIR unless File.exist? APP_CONFIG_DIR
				lockfname = File.join APP_CONFIG_DIR, "lock"
				fd = IO::sysopen( lockfname,
								 Fcntl::O_WRONLY | Fcntl::O_EXCL | Fcntl::O_CREAT)
				f = IO.open(fd)
				f.syswrite( "#{Process.pid}\n" )
				f.close
			rescue Errno::EEXIST => _e
				# test if the other process still exist
				masterpid = File.read(lockfname).strip
				other_path = "/proc/#{masterpid.to_i}"
				STDERR.puts "testing %s" % other_path
				if File.exist? other_path then
					cmdline = File.read( File.join( other_path, 'cmdline' ) )
					if cmdline =~ /qasim/ then
						raise LockError, "Another instance of %s is already running." % APP_NAME
					end
				end
				fd = IO::sysopen( lockfname,
								 Fcntl::O_WRONLY | Fcntl::O_EXCL )
				f = IO.open(fd)
				f.syswrite( "#{Process.pid}\n" )
				f.close
			end
		end

		def lock_unset
			# remove lock if it exists
			lockfname = File.join APP_CONFIG_DIR, "lock"
			return unless File.exist? lockfname
			masterpid = File.read(lockfname).strip
			if masterpid.to_i == Process.pid then
				FileUtils.rm lockfname
			end
		end

		#
		#
		#
		def run
			#Process.daemon(false) #FIXME: add foreground mode too
			lock_set
			@app.exec
			exit 0
		rescue LockError
			STDERR.puts "Error: %s is already running" % APP_NAME
			exit 1
		ensure
			lock_unset
		end


		#
		#
		#
		def self.main
			qasim = QasimGui.new
			qasim.build_interface
			qasim.run
		end

	end

end


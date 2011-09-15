#!/usr/bin/ruby

require 'Qt4'

$DEBUG = true
$VERBOSE = true

require 'pp'
require 'set'
require 'fcntl'

QASIM_INCLUDE_DIR = "."
$:.push QASIM_INCLUDE_DIR

require 'qasim/constants'
require 'qasim/config'
require 'qasim/map'

# QaSiM // Qt Sshfs Mapper 

def _ str
	Qt::Object.tr(str)
end


module Qasim
	class QasimGui


		def initialize
			@config = Config.new
			#@config.parse_cmd_line ARGV

			@map_menu = nil
			@context_menu = nil
			@connect_error = {}
			@connect_running = {}
		end

		def dbus_notify title, body, icon
			bus = Qt::DBusConnection.sessionBus
			if !bus.connected?
				$stderr.puts("Cannot connect to the D-BUS session bus.\n" \
							 "To start it, run:\n" \
							 "\teval `dbus-launch --auto-syntax`\n")
				exit 1
			end
			msg = Qt::DBusMessage.create_method_call( 'org.freedesktop.Notifications',
													 '/org/freedesktop/Notifications',
													 'org.freedesktop.Notifications',
													 'Notify' )
			msg.arguments = [ APP_NAME, Qt::Variant.from_value( 0, "unsigned int" ),
				icon, title, body, [], {}, -1  ]
			rep = bus.call( msg )
			#	if rep.type == Qt::DBusMessage

			#		si.showMessage("Qasim", 
			#					   "Sorry dude", 2, 5000 )
		end


		#
		# Rebuild map menu
		#
		def build_map_menu
			# reload maps dynamically
			@config.parse_maps
			if @map_menu.nil? then
				@map_menu = Qt::Menu.new
			else 
				@map_menu.clear
			end

			previous_host = nil
			@config.maps.sort do |mx,my|
				mx.host <=> my.host
			end.each do |map|
				if map.host != previous_host and not previous_host.nil? then
					@map_menu.addSeparator
				end
				itemx = Qt::Action.new(map.name, @map_menu)
				itemx.setCheckable true;
				if map.connected? then
					itemx.setChecked true
				end
				itemx.connect(SIGNAL(:triggered)) do 
					action_trigger_map_item map, itemx
				end
				@map_menu.addAction itemx;
				previous_host = map.host
			end
		end

		#
		# Action when map item triggered
		#
		def action_trigger_map_item map, item
			@connect_error[map.path] = Set.new
			@connect_running[map.path] = 0
			if map.connected? then
				method = :disconnect
			else
				method = :connect
			end
			begin
				map.send(method) do |linkname,cmd,cmd_args|
					process = Qt::Process.new
					process.connect(SIGNAL('finished(int, QProcess::ExitStatus)')) do |exitcode,exitstatus|
						#puts "exitcode = %s, exitstatus = %s" % [exitcode, exitstatus]
						@connect_running[map.path] -= 1 
						if exitcode != 0 then
							@connect_error[map.path].add linkname
						else
						end
						if @connect_running[map.path] == 0 then
							# display someting
							if @connect_error[map.path].empty? then

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
			@context_menu.addAction act_pref;

			act_about = Qt::Action.new '&About', @context_menu
			act_about.setIcon( Qt::Icon::fromTheme("help-about") ) rescue nil
			act_about.setIconVisibleInMenu true
			act_about.setEnabled false
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
			si  = Qt::SystemTrayIcon.new

			std_icon = Qt::Icon.new( File.join APP_ICON_PATH, "qasim.svg" )
			alt_icon = Qt::Icon.new
			blinking = false

			si.icon  = std_icon
			si.show


			si.setToolTip("Qasim %s" % APP_VERSION);

			build_map_menu
			build_context_menu

			si.contextMenu = @context_menu

			si.connect(SIGNAL('activated(QSystemTrayIcon::ActivationReason)')) do |reason|
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


		#
		#
		#
		def run
			# create lock
			have_lock = true

			FileUtils.mkdir_p APP_CONFIG_DIR unless File.exist? APP_CONFIG_DIR
			lockfname = File.join APP_CONFIG_DIR, "lock"
			fd = IO::sysopen( lockfname,
							 Fcntl::O_WRONLY | Fcntl::O_EXCL | Fcntl::O_CREAT)
			f = IO.open(fd)
			f.syswrite( "#{Process.pid}\n" )
			f.close
			@app.exec
		rescue Errno::EEXIST => e
			# test if the other process still exist
			masterpid = File.read(lockfname).strip
			begin
				Process.kill(0, masterpid.to_i)
				warn "error: Another instance of %s is already running." % APP_NAME
				exit 1
			rescue Errno::ESRCH => e
				fd = IO::sysopen( lockfname,
								 Fcntl::O_WRONLY | Fcntl::O_EXCL )
				f = IO.open(fd)
				f.syswrite( "#{Process.pid}\n" )
				f.close
				@app.exec
			end
		ensure
			masterpid = File.read(lockfname).strip
			if masterpid.to_i == Process.pid then
				FileUtils.rm lockfname
			end
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

Qasim::QasimGui::main


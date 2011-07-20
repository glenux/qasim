#!/usr/bin/ruby

require 'Qt4'

$DEBUG = true
$VERBOSE = true

require 'pp'
require 'qasim/constants'
require 'qasim/config'
require 'qasim/map'

# QaSiM // Qt Sshfs Mapper 

def _ str
	Qt::Object.tr(str)
end


module Qasim

	NAME="Qasim"
	VERSION="0.1"

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
		msg.arguments = [ NAME, Qt::Variant.from_value( 0, "unsigned int" ),
			icon, title, body, [], {}, -1  ]
		rep = bus.call( msg )
		#	if rep.type == Qt::DBusMessage

		#		si.showMessage("Qasim", 
		#					   "Sorry dude", 2, 5000 )
	end

	def build_app

		app = Qt::Application.new(ARGV)
		si  = Qt::SystemTrayIcon.new

		std_icon = Qt::Icon.new( File.join ICON_PATH, "qasim.svg" )
		alt_icon = Qt::Icon.new
		blinking = false

		si.icon  = std_icon
		si.show
		dbus_notify "Hello", "World", 'dialog-information'


		si.setToolTip("Qasim %s" % VERSION);

		Qt::Timer.new(app) do |timer|
			timer.connect(SIGNAL('timeout()')) do
				si.icon = (si.icon.isNull ? std_icon : alt_icon) if blinking
			end
			timer.start(500)
		end

		menu = Qt::Menu.new

		['Diades', 'Daneel', 'Dolos'].each do |name|
			itemx = Qt::Action.new(name, menu)
			itemx.setCheckable true;
			itemx.connect(SIGNAL(:triggered)) do 
				puts "%s => %s" % [name, itemx.checked ] 
			end
			menu.addAction itemx;
		end

		menu.addSeparator

		act_pref = Qt::Action.new _('&Preferences'), menu
		act_pref.setIcon(  Qt::Icon::fromTheme("configure") )
		act_pref.setIconVisibleInMenu true
		menu.addAction act_pref;

		act_about = Qt::Action.new '&About', menu
		act_about.setIcon( Qt::Icon::fromTheme("help-about") )
		act_about.setIconVisibleInMenu true
		menu.addAction act_about;

		menu.addSeparator

		act_quit = Qt::Action.new _('Quit'), menu
		act_quit.setIcon(  Qt::Icon::fromTheme("application-exit") )
		act_quit.setIconVisibleInMenu true
		act_quit.connect(SIGNAL(:triggered)) { app.quit }
		menu.addAction act_quit

		si.contextMenu = menu

		si.connect(SIGNAL('activated(QSystemTrayIcon::ActivationReason)')) do |reason|
			case reason
			when Qt::SystemTrayIcon::Trigger
				blinking = !blinking
				si.icon  = blinking ? alt_icon : std_icon
			when Qt::SystemTrayIcon::MiddleClick:   puts 'Middle Click'
			when Qt::SystemTrayIcon::Context:       puts 'Right Click'
			when Qt::SystemTrayIcon::DoubleClick:   puts 'Double Click'
			end
		end

		app.exec
	end

end

include Qasim
Qasim::build_app


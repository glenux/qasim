#!/usr/bin/ruby

require 'Qt4'
 
app = Qt::Application.new(ARGV)
si  = Qt::SystemTrayIcon.new
 
std_icon = Qt::Icon.new('qtsshfsmapper.svg')
alt_icon = Qt::Icon.new
blinking = false
 
si.icon  = std_icon
si.show
 
Qt::Timer.new(app) do |timer|
  timer.connect(SIGNAL('timeout()')) do
    si.icon = (si.icon.isNull ? std_icon : alt_icon) if blinking
  end
  timer.start(500)
end
 
menu = Qt::Menu.new
 
['Diades', 'Daneel', 'Dolos'].each do |name|
	itemx = Qt::Action.new('Diades', menu)
	itemx.setCheckable true;
	itemx.connect(SIGNAL(:triggered)) { puts itemx.checked }
	menu.addAction itemx;
end

menu.addSeparator

act_pref = Qt::Action.new '&Preferences', menu
menu.addAction act_pref;

act_about = Qt::Action.new '&About', menu
menu.addAction act_about;

menu.addSeparator

act_quit = Qt::Action.new '&Quit', menu
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

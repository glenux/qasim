Qasim (القاسم)
==============

Qasim is a tool born to make your remote shares easily available from the system
tray, on your desktop !

It uses FUSE filesystems, thus everything remains accessible even under
command-line shell, under your favorite operating system (Linux, Windows,
MacOsX).


Requirements
------------

Qasim require the ``qtbindings`` gems. It installs automatically along qasim's
installation, but is quite long to build a native gem package.

**N.B :** If you experience trouble with Qasim dues to Qt bindings, make sure
your Ruby installation was compiled with the ``--enable-shared`` option. 

If it was not, then reinstall it (let's say version 1.9.3-p392) with with :

    $ CONFIGURE_OPTS="--enable-shared" rbenv install 1.9.3-p392


Installation
------------

Simply run :

    $ gem install qasim


Usage
-----

Qasim provide two tools the CLI and the GUI.

To run the GUI :

   $ qasim-gui

Then click on the icon red-yellow-blue icon in the system tray.


Contributing
------------

1. Fork it ( http://github.com/glenux/qasim/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


Copyright & License
-------------------

Copyright (C) 2010-2014 Glenn Y. Rolland

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.


Alternatives
------------

* [Mountoid](http://kde-apps.org/content/show.php/Mountoid?content=115943)


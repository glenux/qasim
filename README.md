# Qasim (القاسم)

[![Travis-CI](https://api.travis-ci.org/glenux/qasim.png?branch=master)](https://travis-ci.org/glenux/qasim) [![Code Climate](https://codeclimate.com/github/glenux/qasim/badges/gpa.svg)](https://codeclimate.com/github/glenux/qasim)

Qasim is a tool born to make your remote shares easily available from the system
tray, on your desktop !

It uses the FUSE filesystem, thus everything gets accessible both on graphical environments and under
command-line shell, on your favorite operating system (Linux, Windows, MacOsX, etc).


## Requirements

Qasim require the `qtbindings` gems. It installs automatically along Qasim's
installation, but is quite long to build a native gem package.

__N.B :__ If you experience trouble with Qasim dues to Qt bindings, make sure
your Ruby installation was compiled with the `--enable-shared` option. If it was not, then reinstall it with the right arguments.

As an example, for ruby 1.9.3-p392 with rbenv :

    $ CONFIGURE_OPTS="--enable-shared" rbenv install 1.9.3-p392


## Installation

To install Qasim, type the following command :

    $ gem install qasim


## Usage

Qasim two tools : the CLI, for command-line environments, and the GUI, for desktop environments.


### Using the CLI 

To run the CLI, type :

    $ qasim-cli command [options]


### Using the GUI

To run the GUI, type :

    $ qasim-gui

Then Qasim icon (![quasim system tray](data/icons/qasim.32.png)) appears in your system tray.  Click on that icon to mount your filesystems, change your preferences, etc.


## Contributing

1. Fork it ( http://github.com/glenux/qasim/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


## Copyright & License

Copyright (C) 2010-2017 Glenn Y. Rolland

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


## Alternatives

If Qasim does not suit your needs, you can try these tools :

* [Mountoid](http://kde-apps.org/content/show.php/Mountoid?content=115943)
* [Xsshfs](http://david.mercereau.info/motclef/xsshfs/)

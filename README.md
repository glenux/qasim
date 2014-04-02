README
======

Requirements
------------

First, make sure your ruby was compiled with the --enable-shared options.
If not, reinstall it (let's say version 1.9.3-p392) with with :

    CONFIGURE_OPTS="--enable-shared" rbenv install 1.9.3-p392

Install the following gems

    qtbindings

Those could also be provided by your linux distribution and installable
with 

    apt-get install libqt4-ruby 

or 

    apt-get install ruby-qt4


Installation
------------

Add this line to your application's Gemfile:

    gem 'qasim'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install qasim


Usage
-----

TODO: Write usage instructions here


Contributing
------------

1. Fork it ( http://github.com/glenux/qasim/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


Copyright & License
-------------------

Copyright (C) 2010-2012 Glenn Y. Rolland

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


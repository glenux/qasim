Global Qasim parameters

* Default local cache directory
* Default mount point directory

* AutoSSH (disable if not installed)
    * autossh executable path
    * use autossh (default: yes)
* Unison (disable if not installed)
    * unison executable path
    * use unison (default: yes)
    * sync interval (0=none, ...) in hours

Global SSHFS Options

* reconnect (default: yes)
* compress (default: yes)
* transform_symlinks (default: yes)
* ServerAliveInterval (default: 30)
* ServerAliveCountMax (default: 30)

ssh_command='autossh -M 0'


Fixes

Use Rakefile
ex: https://github.com/ryanmelt/qtbindings/blob/master/Rakefile

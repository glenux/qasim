TODO
====

## Use Rakefile instead of Makefile

* Make sure .ui and .qrc files are build before .gem

ex: https://github.com/ryanmelt/qtbindings/blob/master/Rakefile

## Plugin support

Rewrite maps as a factory for plugins

## Parameters

### Global options

* Default local cache directory
* Default mount point directory
* Idle time umount

### SSHFS

* Use AutoSSH (disable if not installed)
    * use autossh (default: yes)
	* ssh_command='autossh -M 0'

* SSH options
	* reconnect (default: yes)
	* compress (default: yes)
	* transform_symlinks (default: yes)
	* ServerAliveInterval (default: 15)
	* ServerAliveCountMax (default: 3)
	* Cipher (default: blowfish) # for speed & security


### FTP

* 

### WebDav

* Detect fusedav presence on system

### Local sync

* Unison (disable if not installed) :

   * unison executable path
   * use unison (default: yes)
   * sync interval (0=none, ...) in hours


### Programs

(Checkbox for each program)

* sshfs executable path (default: empty)
* curlftpfs executable path (default: empty)
* fusedav executable path (default: empty)
* autossh executable path (default: empty)
* unison executable path (default: empty)

### Implement StatusNotifierItem

Inspiration code : https://github.com/sandsmark/quassel-proxy/commit/b858144c9d38623bdd9afaa02c404d9515243ab7



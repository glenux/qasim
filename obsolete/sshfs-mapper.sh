#!/bin/sh
# vim: set ts=2 sw=2 :
set -u


################################################################################
##
## Variables initializations
##

set |grep -q '^XDG_CONFIG_HOME' || XDG_CONFIG_HOME="$HOME/.config"
SSHFS_DIR="$XDG_CONFIG_HOME/sshfs-mapper"
SSHFS_CONFIG="$SSHFS_DIR/config"
SSHFS_MOUNT=1
SSHFS_HOSTS_SELECTION=0


################################################################################
##
## Functions definitions
##

read_conf() {
	local config=$1
	local var=$2
	local value="`eval echo \`cat $config |grep "^$2=" |sed "s/$2=//"\``"
	echo "$value"
}

do_mount() {
  local remotedir=$1
  local localdir=$2
  local remoteport=$3

	set -x
  sshfs \
    -o allow_root \
    -o idmap=user \
    -o uid=`id -u` \
    -o gid=`id -g` \
    -o reconnect \
    -o workaround=all \
    -o cache_timeout=240 \
		-o ServerAliveInterval 15 \
		-o no_readahead \
    -o Ciphers=arcfour \
    -o Port=$remoteport \
    $remotedir \
    $localdir
	set +x

  #-o compression=yes
}

do_umount() {
  local remotedir=$1
  local localdir=$2
  fusermount -u $localdir
}

do_usage() {
  cat >&2 <<EOF
Usage: `basename $0` [options]
-h, --help            Show this help and exit.
-i, --init            Initialize user configuration.
-l, --list            List available maps.
-a, --all             Use all maps.
-s, --select <map>    Only use specified map.
-u, --umount          Umount user maps (mount if not specified).
-v, --verbose         Be verbose.
EOF
exit 1
}

do_initialize()
{
  echo "Initializing user maps..."
  if [ -e "$SSHFS_DIR" ]; then
    echo -e "\nERROR: Configuration directory already exists!" >&2 
    echo "To erase your setup, please manually remove directory \"$SSHFS_DIR\" first." >&2
    exit 1
  else
    mkdir -p "$SSHFS_DIR" 
    cat > "$SSHFS_DIR/config" <<EOF
MOUNTPOINT=\$HOME/mnt
LINKTO=\$HOME
EOF

    cat > "$SSHFS_DIR/default.map" <<EOF
REMOTE_USER=\$USER
REMOTE_HOST=example.com
REMOTE_PORT=22

MAP=RemoteDocs /home/\$USER/Documents
MAP=RemoteMusic /home/\$USER/Music
EOF
				echo -e "\nManually edit configuration files in \"$SSHFS_DIR\""
				echo "to adjust sshfs-mapper configuration to your settings."
				echo -e "\nType \"man sshfs-mapper\" to get more help."

				exit 0
				fi
}


################################################################################
##
## Parse options and mount/umount
##

SSHFS_HOST_PATTERN=" "
SSHFS_HOST_LIMIT=0
SSHFS_HOST_LIST=0
SSHFS_HOST_AUTO=0
SSHFS_VERBOSE=0
OPTFOUND=0
while true
do
  OPT=${1:-}
  if [ -z $OPT ]; then break ; fi
  shift
  OPTARG=${1:-}
  #echo "$OPT?"
	case "$OPT" in
		--verbose|-v) #be verbose
			SSHFS_VERBOSE=1
			;;
		--all|-a)  # mount all
			SSHFS_HOST_AUTO=1
			OPTFOUND=1
			;;
		--init|-i)  # init (copy config files in user HOME)
			do_initialize
			OPTFOUND=1
			;;
		--umount|-u)  # umount
			echo "Umounting..."
			SSHFS_MOUNT=0
			OPTFOUND=1
			;;
		--select|-s)  # only selected hosts
			SSHFS_HOST_PATTERN="${SSHFS_HOST_PATTERN}${OPTARG} "
			SSHFS_HOST_LIMIT=1
			shift
			OPTFOUND=1
			;;
		--list|-l)
			SSHFS_HOST_LIST=1
			OPTFOUND=1
			;;
		--help|-h)
			do_usage
			OPTFOUND=1
			;;
		*) 
			do_usage
			OPTFOUND=1
			;;
	esac
done
if [ $OPTFOUND -eq 0 ]; then
  do_usage
fi

if [ ! -e $SSHFS_DIR ]; then mkdir $SSHFS_DIR ; fi
if [ ! -e $SSHFS_DIR ]; then
	echo -e "\nERROR: Unable to create $SSHFS_DIR" >&2
	exit 1
fi

if [ ! -e "$SSHFS_CONFIG" ]; then
	echo "MOUNTPOINT=\$HOME/mnt" >> "$SSHFS_CONFIG"
fi
if [ ! -e "$SSHFS_CONFIG" ]; then
	echo -e "\nERROR: Unable to find config file." >&2
	exit 1
fi

for map_file in $SSHFS_HOST_PATTERN; do
  if [ ! -e "$SSHFS_DIR/$map_file.map" ]; then
    echo -e "\nERROR: Unable to find map file '$map_file.map'." >&2
  fi
done

mountpoint=$( read_conf "$SSHFS_CONFIG" MOUNTPOINT )
if [ "x$mountpoint" = "x" ]; then
	echo -e "\nERROR: Mountpoint undefined." >&2
  echo "Edit mountpoint definition in \"$SSHFS_CONFIG\"" >&2
	exit 1;
fi

is_mounted() {
  local map_name=$1

  mount | grep -q " $mountpoint/$map_name "
  return $?
}

for map_file in `find "$SSHFS_DIR" -follow -type f -name '*.map' `; do
  if [ $SSHFS_HOST_LIST -eq 1 ]; then
    basename `echo ${map_file} | sed 's/.map$//'`
    continue
  fi
  if [ $SSHFS_HOST_LIMIT -eq 1 ]; then
    if ! echo "$SSHFS_HOST_PATTERN" | grep -q " `basename \`echo ${map_file} |sed s'/.map$//' \`` " ; then
      continue
    fi
  else
    if [ $SSHFS_HOST_AUTO -eq 0 ]; then
      continue
    fi
  fi
	remote_host=$( read_conf $map_file REMOTE_HOST )
	remote_user=$( read_conf $map_file REMOTE_USER )
	remote_port=$( read_conf $map_file REMOTE_PORT )
	map=$( read_conf $map_file MAP )
	echo "Map: $remote_user@$remote_host"

  nc -z $remote_host $remote_port > /dev/null 2>&1
  if [ $? != 0 ]; then
    echo "  ERROR: can't find the server at $remote_host:$remote_port"
    continue
  fi

  map_count=0
  map_name=""
  remote_dir=""
  for map_item in $map; do
    if [ $map_count = 0 ]; then map_name=$map_item ; fi
    if [ $map_count = 1 ]; then remote_dir=$map_item ; fi
    map_count=$(( ( $map_count + 1 ) % 2 ))
    if [ $map_count = 0 ]; then
      echo "  $map_name => $remote_dir"
      if ! is_mounted $map_name  ; then
        if [ $SSHFS_MOUNT = 1 ]; then
          mkdir -p $mountpoint/$map_name
          do_mount $remote_user@$remote_host:$remote_dir $mountpoint/$map_name $remote_port
          rm -f $HOME/$map_name
          ln -s $mountpoint/$map_name $HOME/$map_name
        fi
      else
        if [ $SSHFS_MOUNT = 0 ]; then
          do_umount $remote_user@$remote_host:$remote_dir $mountpoint/$map_name
          rm -f $HOME/$map_name
        fi
        if [ $SSHFS_MOUNT = 1 ]; then
           echo "    (Already mounted on $mountpoint/$map_name)"
        fi
      fi 
    fi
	done
done


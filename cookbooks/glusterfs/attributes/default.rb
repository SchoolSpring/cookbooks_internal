# These are the names of the RightScale tags used on the servers.  We define
# them here so we don't hardcode the names all throughout the code.
default_unless[:glusterfs][:tag][:mounted]  = "glusterfs_server:mounted"
default_unless[:glusterfs][:tag][:mount]    = "glusterfs_server:mount"
default_unless[:glusterfs][:tag][:spare]    = "glusterfs_server:spare"
default_unless[:glusterfs][:tag][:attached] = "glusterfs_server:attached"
default_unless[:glusterfs][:tag][:volume]   = "glusterfs_server:volume"
default_unless[:glusterfs][:tag][:brick]    = "glusterfs_server:brick"

default_unless[:glusterfs][:server][:replica_count] = "2"
default_unless[:glusterfs][:server][:spares] = []

default_unless[:glusterfs][:client][:pkg_name] = "glusterfs_3.2.7-1_amd64.deb"
default_unless[:glusterfs][:client][:mount_options] = ""

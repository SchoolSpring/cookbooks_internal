maintainer       "RightScale, Inc."
maintainer_email "support@rightscale.com"
license          "Apache 2.0"
description      "GlusterFS recipes" 
version          "0.0.2"

depends "rightscale"
depends "block_device"
#depends "aria2"

recipe "glusterfs::default", "Currently unused"
recipe "glusterfs::install", "Downloads and installs GlusterFS"
recipe "glusterfs::server_configure", "Configures glusterd"
recipe "glusterfs::server_set_tags", "Adds 'glusterfs_server:*' tags so other servers can find us"
recipe "glusterfs::server_create_cluster", "Finds other servers tagged as 'spare=true' and initializes the GlusterFS volume"
recipe "glusterfs::server_join_cluster", "Finds an existing/joined GlusterFS server and request to be attached to the cluster"
recipe "glusterfs::server_decommission", "Removes bricks from the volume, detaches from the cluster and resets some tags"
recipe "glusterfs::server_handle_probe_request", "Remote recipe intended to be called by glusterfs::server_{create,join}_cluster"
recipe "glusterfs::server_handle_tag_updates", "Remote recipe intended to be called by glusterfs::server_{create,join}_cluster"
recipe "glusterfs::server_handle_detach_request", "Remote recipe intended to be called by glusterfs::server_decommission"
recipe "glusterfs::client_mount_volume", "Runs mount(8) with `-t glusterfs' option to mount glusterfs"
recipe "glusterfs::sync_volumes", "Syncronizes mount points in the pool using unison"
recipe "glusterfs::clone_from_bucket", "Pulls all the files from the s3 bucket to a specified path"

attribute "glusterfs/server/aws_access_key_id",
    :display_name => "Access Key ID",
    :description  => "Amazon AWS Access Key ID",
    :required     => "required",
    :recipes      => [ "glusterfs::default",
                       "glusterfs::clone_from_bucket" ]

attribute "glusterfs/server/aws_access_key_secret",
    :display_name => "Access Key Secret",
    :description  => "Amazon AWS Access Key Secret",
    :required     => "required",
    :recipes      => [ "glusterfs::default",
                       "glusterfs::clone_from_bucket" ]

attribute "glusterfs/server/bucket_name",
    :display_name => "S3 bucket",
    :description  => "S3 Bucket Name",
    :required     => "required",
    :recipes      => [ "glusterfs::default",
                       "glusterfs::clone_from_bucket" ]

attribute "glusterfs/server/volume_type",
    :display_name => "Volume Type",
    :description  => "The type of GlusterFS volume to create (distributed, replicated, etc)",
    :required     => "optional",
    :default      => "Replicated",
    :choice       => [ "Distributed", "Replicated" ],
    :recipes      => [ "glusterfs::default",
                       "glusterfs::server_create_cluster",
                       "glusterfs::server_join_cluster" ]

attribute "glusterfs/volume_name",
    :display_name => "Volume Name",
    :description  => "The name of the GlusterFS volume. Servers are tagged with this name and trusted pools are keyed off this name, meaning everyone who shares the same name will become part of the same pool/volume",
    :required     => "required",
    :recipes      => [ "glusterfs::default",
                       "glusterfs::server_set_tags",
                       "glusterfs::server_create_cluster",
                       "glusterfs::server_join_cluster",
                       "glusterfs::client_mount_volume" ]

attribute "glusterfs/sync/local",
    :display_name => "Local sync",
    :description  => "Local side of the unison sync command",
    :required     => "required",
    :recipes      => [ "glusterfs::sync_volumes" ]

attribute "glusterfs/sync/remote",
    :display_name => "Remote sync",
    :description  => "Remote side of the unison sync command",
    :required     => "required",
    :recipes      => [ "glusterfs::sync_volumes" ]

attribute "glusterfs/server/storage_path",
    :display_name => "Storage Path",
    :description  => "The directory path to be used as a brick and added to the GlusterFS volume",
    :required     => "required",
    :recipes      => [ "glusterfs::default",
                       "glusterfs::server_set_tags",
                       "glusterfs::server_create_cluster",
                       "glusterfs::server_join_cluster" ]

attribute "glusterfs/server/replica_count",
    :display_name => "Replica Count",
    :description  => "The number of bricks to replicate files across for a Replicated volume type",
    :required     => "optional",
    :default      => "2",
    :recipes      => [ "glusterfs::default",
                       "glusterfs::server_create_cluster",
                       "glusterfs::server_join_cluster" ]

attribute "glusterfs/client/mount_point",
    :display_name => "Mount point",
    :description  => "(Client only) The directory path where the GlusterFS volume should be mounted (e.g., /mnt/storage).",
    :type         => "string",
    :required     => "recommended",
    :default      => "/mnt/ephemeral/glusterfs",
    :recipes      => [ "glusterfs::default",
                       "glusterfs::client_mount_volume" ]

attribute "glusterfs/client/mount_options",
    :display_name => "Mount Options",
    :description  => "(Client only) Extra options to be passed to the mount command",
    :required     => "optional",
    :recipes      => [ "glusterfs::default",
                       "glusterfs::client_mount_volume" ]

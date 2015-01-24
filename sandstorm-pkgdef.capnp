@0xb343d76ff4c073a8;

using Spk = import "/sandstorm/package.capnp";
# This imports:
#   $SANDSTORM_HOME/latest/usr/include/sandstorm/package.capnp
# Check out that file to see the full, documented package definition format.

const pkgdef :Spk.PackageDefinition = (
  # The package definition. Note that the spk tool looks specifically for the
  # "pkgdef" constant.

  id = "c70z5uedne10skkkm4pe2mctpp71kkteu6j7xuqpc0cjezu3gvfh",
  # Your app ID is actually its public key. The private key was placed in
  # your keyring. All updates must be signed with the same key.

  manifest = (

    appVersion = 0,  # Increment this for every release.

    actions = [
      # Define your "new document" handlers here.
      ( title = (defaultText = "New Lobsters Instance"),
        command = .startCommand
      )
    ],

    continueCommand = .continueCommand
  ),

  sourceMap = (
    # Here we defined where to look for files to copy into your package. The
    # `spk dev` command actually figures out what files your app needs
    # automatically by running it on a FUSE filesystem. So, the mappings
    # here are only to tell it where to find files that the app wants.
    searchPath = [
      ( sourcePath = "." ),  # Search this directory first.
      ( sourcePath = "/",    # Then search the system root directory.
        hidePaths = [ "home", "proc", "sys", "lib",
                      "etc/passwd", "etc/hosts", "etc/host.conf",
                      "etc/nsswitch.conf", "etc/resolv.conf" ]
      )
    ]
  ),

  fileList = "sandstorm-files.list",

  alwaysInclude = ["lobsters/app", "lobsters/config", "lobsters/public"],

  bridgeConfig = (
    viewInfo = (
     permissions = [(name = "admin"), (name = "moderator")]
    )
  )
);

const startCommand :Spk.Manifest.Command = (
  # Here we define the command used to start up your server.
  argv = ["/sandstorm-http-bridge", "10000", "--", "/bin/sh", "start.sh"],
  environ = [
    # Note that this defines the *entire* environment seen by your app.
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin")
  ]
);


const continueCommand :Spk.Manifest.Command = (
  argv = ["/sandstorm-http-bridge", "10000", "--", "/bin/sh", "continue.sh"],
  environ = [
    (key = "PATH", value = "/usr/local/bin:/usr/bin:/bin")
  ]
);

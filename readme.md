ec2bt
-----
`upstart` service for EC2 instances that logs backtraces from coredumps. Currently logs to `syslog`.

### Install from S3

Set `EC2BT_PROGRAM_PATH` to the filepath of the program you want to generate backtraces for.

```
$ curl https://s3.amazonaws.com/mapbox/apps/ec2bt/v0.0.1 | EC2BT_PROGRAM_PATH=$(which node) bash
```

You will probably need to set:

```sh
ulimit -c unlimited -S
```

To enable backtraces on your system.

#!/usr/bin/env bash

set -u

# cleanup any previous state
sudo stop ec2bt &> /dev/null || true
sudo rm -f /etc/init/ec2bt.conf
sudo rm -rf /tmp/ec2bt

# test exit code
code=0

msg="ec2bt not running"
sudo status ec2bt &> /dev/null
([ $? == 1 ] && echo "ok - $msg") || (echo "not ok - $msg" && code=1)

msg="/etc/init/ec2bt.conf does not exist"
(! [ -f /etc/init/ec2bt.conf ] && echo "ok - $msg") || (echo "not ok - $msg" && code=1)

msg="exit 1 without env var"
export EC2BT_PROGRAM_PATH=
out=$(sudo -E $(dirname $0)/../bin/ec2bt)
([ $? == 1 ] && echo "ok - $msg") || (echo "not ok - $msg" && code=1)

msg="shows usage"
echo $out | grep -q "Usage:"
([ $? == 0 ] && echo "ok - $msg") || (echo "not ok - $msg" && code=1)

msg="exit 1 on bad path"
export EC2BT_PROGRAM_PATH=/foo/bar/baz
out=$(sudo -E $(dirname $0)/../bin/ec2bt)
([ $? == 1 ] && echo "ok - $msg") || (echo "not ok - $msg" && code=1)

msg="shows path error"
echo $out | grep -q "Program path /foo/bar/baz could not be found"
([ $? == 0 ] && echo "ok - $msg") || (echo "not ok - $msg" && code=1)

msg="exit 0 on good install"
export EC2BT_PROGRAM_PATH=$(which node)
out=$(sudo -E $(dirname $0)/../bin/ec2bt)
([ $? == 0 ] && echo "ok - $msg") || (echo "not ok - $msg" && code=1)

msg="ec2bt is running"
sudo status ec2bt &> /dev/null
([ $? == 0 ] && echo "ok - $msg") || (echo "not ok - $msg" && code=1)

msg="/etc/init/ec2bt.conf exists"
([ -f /etc/init/ec2bt.conf ] && echo "ok - $msg") || (echo "not ok - $msg" && code=1)

exit $code

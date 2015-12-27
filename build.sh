#!/usr/bin/env bash
set -e

ACBUILD="/opt/bin/acbuild --debug"

acbuildend () {
    export EXIT=$?;
    $ACBUILD end && exit $EXIT;
}

wget https://github.com/prometheus/alertmanager/archive/0.1.0-beta0.tar.gz -O alertmanager.tar.gz
mkdir -p tmp
tar xvf alertmanager.tar.gz -C tmp/ --strip-components=1
$ACBUILD begin /home/core/aci-store/centos-base.aci
trap acbuildend EXIT

$ACBUILD set-name f0/alertmanager
$ACBUILD copy ./tmp /alertmanager
$ACBUILD run -- mkdir /data
$ACBUILD copy alertmanager.yaml /alertmanager.yaml 
$ACBUILD run -- useradd -m alertmanager -s /bin/false -u 5000
$ACBUILD set-user 5000
$ACBUILD set-exec -- /alertmanager/alertmanager -config.file=/alertmanaer.yaml 
$ACBUILD write --overwrite /home/core/aci-store/alertmanager.aci



#!/bin/bash
set -eux
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
objdump -d -M intel $1 -r | grep cov_trace_pc | cut -d ":" -f1 | sed 's/^[ \t]*//' | sed 's/^/0x/g' | cut -c "1-18" > "/tmp/tmp1"
echo "/tmp/tmp1" | python3 $SCRIPT_DIR/add4.py > "/tmp/tmp2"

perl -e '@l=<>;print sort {hex($a)<=>hex($b)} @l' < "/tmp/tmp2" | uniq > "/tmp/tmp1"
addr2line -e $1 -i  < "/tmp/tmp1"| cut -d "/" -f5-| cut -d"(" -f1 | sed -e "s/ //g"|sed -e "s/\/.\//\//g"| sort | uniq > /tmp/tmp

cat /tmp/tmp  | grep -v "\.\." > /tmp/tmp1
cat /tmp/tmp  | grep "\.\." | $SCRIPT_DIR/resolve_path.sh >> /tmp/tmp1
cat /tmp/tmp1 | sort -t: -k1,1 -k2n| uniq |grep kvm

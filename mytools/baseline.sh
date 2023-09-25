#!/bin/bash
set -eux
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

while getopts "b:c:" opt
do
   case $opt in
      b) bin="$OPTARG";;
      c) rawcov="$OPTARG";;
      \?) echo "Usage: $0 [-b bin] [-c rawcov]" 1>&2
          exit 1;;
   esac
done

if [ -z "${bin+x}" ]; then
    echo "Error: -b option is required" 1>&2
    exit 1
fi

if [ -z "${rawcov+x}" ]; then
    objdump -d -M intel $bin -r | grep cov_trace_pc | cut -d ":" -f1 | sed 's/^[ \t]*//' | sed 's/^/0x/g' | cut -c "1-18" > "/tmp/tmp1"
    echo "/tmp/tmp1" | python3 $SCRIPT_DIR/add4.py > "/tmp/tmp2"
    perl -e '@l=<>;print sort {hex($a)<=>hex($b)} @l' < "/tmp/tmp2" | uniq > "/tmp/tmp1"
    rawcov="/tmp/tmp1"
fi

addr2line -e $bin -i  < $rawcov | cut -d "/" -f5-| cut -d"(" -f1 | sed -e "s/ //g"|sed -e "s/\/.\//\//g"| sort | uniq > /tmp/tmp

cat /tmp/tmp  | grep -v "\.\." > /tmp/tmp1
cat /tmp/tmp  | grep "\.\." | $SCRIPT_DIR/resolve_path.sh >> /tmp/tmp1
cat /tmp/tmp1 | sort -t: -k1,1 -k2n| uniq |grep kvm

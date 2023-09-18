# mkdir "cov_result/$2" -p

max=590
for ((i=0; i < $max; i++)); do

if [ $i -eq 0 ]; then
echo "$1" | python3 add5.py > tmp
else
echo "$1.$i" | python3 add5.py > tmp
fi
# echo $1 | python3 add-5.py > "cov_result/$2/$2-5"
addr2line -e ~/work/linux/vmlinux -i < tmp |  grep -v "?"|cut -d "/" -f5- |cut -d"(" -f1|sed -e "s/ //g" |sed -e "s/\/.\//\//g" | sort | uniq > "tmp1"
grep "tmp1" -f baseline.txt > hoge
# grep hoge -f loadable_baseline > "cov_result/$2/$2_all"
# mv hoge "tmp"

grep "vmx/nested.c" hoge | grep -v "?"| cut -d ":" -f2 > cov_nested
wc cov_nested -l
done
# perl -e '@l=<>;print sort {hex($a)<=>hex($b)} @l' < tmp > 


# echo $1 | python3 sub-4.py > tmp
# cat "cov_result/$2/$2_all" |grep "vmx/vmx.c"| grep -v "?"| cut -d ":" -f2  > tmp
# addr2line -e ~/work/linux/vmlinux -i < "$1" |grep vmx.c: | sort | uniq | cut -d ":" -f2 | cut -d"(" -f1 > tmp1
# perl -e '@l=<>;print sort {hex($a)<=>hex($b)} @l' < tmp > "cov_result/$2/$2_vmx"
# echo "cov_result/$2/$2_nested" | python3 make_nested.py 
# echo "cov_result/$2/$2_vmx" | python3 make_vmx.py 
# python3 make_all_html.py cov_result/baseline_vmlinux/baseline_vmlinux_all "cov_result/$2/$2_all"

# cat "cov_result/$2/$2_all"  | cut -d ":" -f1 | uniq -c |sort -n -r > "cov_result/$2/line_$2"
# cat "cov_result/$2/line_$2"  | awk -F" " '{print "|" $2"|" $1"|"}' >"cov_result/$2/line_$2_table"
# python3 cov_table.py "cov_result/baseline_vmlinux/line_baseline_vmlinux_table" "cov_result/$2/line_$2_table"
# echo "cov_result/$2_vmx" | python3 make_vmx_c.py 



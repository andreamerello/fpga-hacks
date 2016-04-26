#!/bin/bash

# Cleans up ISE project, intentionally leaving here
# files .xst .prj .ut because I use them in other scripts

DEL_WILDCARDS="
*.bgn
*.bit
*.bld
*.cmd_log
*.drc
*.lso
*.ncd
*.ngc
*.ngd
*.ngr
*.pad
*.par
*.pcf
*.ptwx
*.stx
*.syr
*.twr
*.twx
*.unroutes
*.xpi
*_envsettings.html
*_map.map
*_map.mrp
*_map.ncd
*_map.ngm
*_map.xrpt
*_ngdbuild.xrpt
*_pad.csv
*_pad.txt
*_par.xrpt
*_summary.html
*_summary.xml
*_usage.xml
*_xst.xrpt
*_bitgen.xwbt
bitgen.xmsgs
map.xmsgs
ngdbuild.xmsgs
par.xmsgs
trce.xmsgs
xst.xmsgs
usage_statistics_webtalk.html
webtalk.log
webtalk_pn.xml"

rm -Rf _ngo
rm -Rf xlnx_auto_0_xdb
rm -Rf xst
rm -Rf _xmsgs

for i in $DEL_WILDCARDS;
do
     rm -f $i
done

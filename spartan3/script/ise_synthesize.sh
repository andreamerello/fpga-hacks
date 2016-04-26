#!/bin/bash

#
# Tries to synthesize a ISE project without using the damn GUI
# Needs the .xst file as first argument
#
# NOTE: probably works only with Spartan 3AN or maybe just few others.
#

ISE_DIR=/opt/Xilinx/14.7/ISE_DS
#PART="xc3s700an-fgg484-4"

XST_FILE=`basename $1`
PROJ_DIR=`dirname $1`
PROJ_NAME=`echo $XST_FILE |rev | cut -d'.' -f 2- |rev`

# relative to PROG_DIR
LOG_DIR=log
# relative to PROG_DIR
OUT_DIR=build
# constaints, pins..
UCF_FILE=$PROJ_NAME.ucf
# bitstream config options
UT_FILE=$PROJ_NAME.ut
OUT_PREFIX=$OUT_DIR/$PROJ_NAME

GREEN='\033[92m'
RED='\033[91m'
YELLOW='\033[93m'
BLUE='\033[94m'
BOLD='\033[44m'
UNDERLINE='\033[4m'

function colorecho() {
    echo -en $1
    echo ${@:2}
    tput sgr0
}

function fatal() {
    echo ""
    colorecho $RED $1
    exit -1
}

function run() {
    CMD=${@:3}
    STEP_NAME=$1
    LOG_NAME=$2

    echo ""
    colorecho $GREEN $STEP_NAME..
    colorecho $BLUE -ne "Running:\040"
    colorecho $BOLD -n $CMD
    echo ""
    echo ""

    echo $CMD >> $LOG_DIR/cmds.log
    echo "" >> $LOG_DIR/cmds.log
    $CMD | tee $LOG_DIR/$LOG_NAME.log
    if [ "${PIPESTATUS[0]}" -ne 0 ]
    then
	echo " "
	fatal "-- Process FAILED :("
    fi
}

if [ $# -ne 1 ]
then
    fatal "plase specify XST file"
fi

if [ ! -f $1 ]
then
    fatal "File not found: $1"
fi

PART=`cat $1 |grep "^-p " |cut -d ' ' -f2`

colorecho $GREEN -en "Using part:\040"
colorecho $GREEN$UNDERLINE $PART


colorecho $GREEN -en "Entering directory:\040"
colorecho $GREEN$UNDERLINE $PROJ_DIR
cd $PROJ_DIR

if [ ! -f $UCF_FILE ]
then
    fatal "File not found: $UCF_FILE"
fi

if [ ! -f $UT_FILE ]
then
    fatal "File not found: $UT_FILE"
fi

colorecho $GREEN -en "UCF file:\040"
colorecho $GREEN$UNDERLINE $UCF_FILE

colorecho $GREEN -en "UT file:\040"
colorecho $GREEN$UNDERLINE $UT_FILE

colorecho $GREEN -ne "Logging directory:\040"
colorecho $GREEN$UNDERLINE $PROJ_DIR/$LOG_DIR
echo ""

mkdir -p $OUT_DIR
mkdir -p $LOG_DIR
rm -f $LOG_DIR/cmds.log

echo -en $BLUE
colorecho $GREEN Sourcing ISE settings..
source $ISE_DIR/settings64.sh
tput sgr0

colorecho $GREEN -en "Firing ISE workflow. Synthesys for project:\040"
colorecho $GREEN$UNDERLINE $PROJ_NAME

run "Synthesis" "xst" xst -intstyle xflow -ifn $XST_FILE -ofn $LOG_DIR/xst_ext.log
mv *.ngc $OUT_DIR

run "Translate" "translate" ngdbuild -intstyle xflow -dd _ngo -nt timestamp -uc $UCF_FILE -p $PART $OUT_PREFIX.ngc $OUT_PREFIX.ngd

#run "T2" "t2" /opt/Xilinx/14.7/ISE_DS/ISE/bin/lin64/unwrapped/ngdbuild -intstyle xflow -dd _ngo -nt timestamp -uc $UCF_FILE -p $PART $OUT_PREFIX.ngc $OUT_PREFIX.ngd

run "MAP" "map" map -intstyle xflow -p $PART -cm area -ir off -pr off -c 100 -o "$OUT_PREFIX"_map.ncd $OUT_PREFIX.ngd $OUT_PREFIX.pcf

run "Place & Route" "par" par -w -intstyle xflow -ol high -t 1 "$OUT_PREFIX"_map.ncd $OUT_PREFIX.ncd $OUT_PREFIX.pcf

run "Post-Place & Route Static Timing" "trce" trce -intstyle xflow -v 3 -s 4 -n 3 -fastpaths -xml $OUT_PREFIX.twx $OUT_PREFIX.ncd -o $OUT_PREFIX.twr $OUT_PREFIX.pcf -ucf $UCF_FILE

run "Generating bitstream" "bitgen" bitgen -intstyle xflow -f $UT_FILE $OUT_PREFIX.ncd

echo ""
colorecho $GREEN "Design synthesis COMPLETED !"

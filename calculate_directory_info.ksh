#!/bin/ksh -u
################################################################################
# command : find / -ls
# sample output (linux) :
# 524353   12 drwxr-xr-x   2 root     root         8192 Apr 15 20:53 /boot/grub2/i386-pc
# 524354    8 -rw-r--r--   1 root     root         8072 Apr 15 20:53 /boot/grub2/i386-pc/gcry_rmd160.mod
# ------------------------------------------------------------------------------
# inode#  size attribute   ? user     group        ?    date   time  file/directory 
################################################################################

if [[ $# -ne 1 ]] ; then
echo "$0 <input file>"
exit
fi

########################################
#  define variable 
########################################

SCRIPT_FILE=$(basename $0)
FIND_OUTPUT=$1
SKPI_KEY="^$|proc"

########################################
#  main 
########################################

grep -vE ${SKPI_KEY}  "${FIND_OUTPUT}"  | awk 'BEGIN {

}

{
if ( NF == 11 ) 
    {  SUM_FILES=SUM_FILES+1 ; z=split($0,ARRAY_find_ls," " )
    if ( ARRAY_find_ls[3] ~  /d/) 
        { 
        DIR_ATTRIBUTE=ARRAY_find_ls[3] 
        DIR_NAME=ARRAY_find_ls[11]
        DIR_COUNT[DIR_ATTRIBUTE]=DIR_COUNT[DIR_ATTRIBUTE]+1 
        DIR_FILES_COUNT[DIR_NAME]=0
        DIR_FILES_SIZE[DIR_NAME]=0
        }
    if ( ARRAY_find_ls[3] !~ /d/ && $11  ~ DIR_NAME ) 
        {
        FILE_COUNT=FILE_COUNT+1 
        DIR_FILES_COUNT[DIR_NAME]=FILE_COUNT 
        DIR_FILES_SIZE[DIR_NAME]=DIR_FILES_SIZE[DIR_NAME]+ARRAY_find_ls[2]
        }
    }
}


END {

################################################################################
# sample output :
# directory | total files | total size (KB)
################################################################################

for ( INDEX in  DIR_FILES_COUNT ) { print INDEX"|"DIR_FILES_COUNT[INDEX]"|"DIR_FILES_SIZE[INDEX] } 
# for ( INDEX in  DIR_COUNT ) { print INDEX,DIR_COUNT[INDEX] }

}'

########################################
#  clean temp files 
########################################


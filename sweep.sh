#!/bin/bash
##
# contains a dir with many git repos -> one level 
#         /gitrepob
#         /gitrepoa
#   /root 
#         /gitrepoc
#         /gitrepod
##
ROOT_DIR=$1;

##
# the depth to which a search should be performed 
# beyond the root dir if .git IS NOT found
# ie 2
# PASS
# /gitrepob/.git 
# /gitrepob/data/.git
# FAILED
# /gitrepod/cgi-bin/ <-- no .git? stop!
#
##
SEARCH_DEPTH=$2;

#void --> msg + value
function print_warn ()
{
   printf "$1"' : %s\n' "$2"
}


function dive_dir ()
{
  dir_init=$1
  sleep 1; 
  if [ -n $2 ];
   then
   depth_init=$2
   print_warn "THIS IS DEPTH" $2    
  else
    depth_init=0  
  fi

  for directory in $dir_init;
  do
    if [ -d $directory ];
     then
     	 #for (( depth=0; $SEARCH_DEPTH > depth; ++depth ))
     	 #do
         ##
         ## logic ends here if git repo - exit
         ##
            print_warn "THIS IS THE DIR EVAL" $directory
            verify_git_repo $directory
         #echo $directory;
     	 # done
        
         for (( depth_init2=$(($depth_init));  depth_init2 <= "$SEARCH_DEPTH"; ++depth_init2));
         do              
	      print_warn "depth" $depth_init2	
              dive_dir  $directory $depth_init2
         done
      fi
         return
  done
}



function verify_git_repo ()
{
  directoy=$1
  IS_GIT=${directory:${#directory}  -4}
   
  ##
  ## strong quoting nothing is interperted ''
  ##
  if [ "$IS_GIT" = ".git" ]
  then
       print_warn "THIS IS THE GIT REPO FOUND" $IS_GIT 
       get_timestamp $directory
  fi
}

function get_timestamp ()
{
	directory=$1
	arr=($(tail -n 1  $directory/logs/HEAD)) 
        
	print_warn "MOST RECENT REPO UNIXTIME" "${arr[4]}"

        mytime=`date +%s`
        print_warn "SYS TIME" "$mytime"

        TIME_DIFF_IN_SEC=($mytime - ${arr[4]})         
        print_warn "LAST MOD" "$TIME_DIFF_IN_SEC"

        if [ $TIME_DIFF_IN_SEC -gt 86400 ]
          then
             print_warn "REPO AGED BEFORE TODAY"
             #
             # continued proc --> no commit found within 24hr
             #
        else
             print_warn "REPO AGED TODAY"
             sleep 3;
             #
             # kill proc --> freshness found
             #
        fi
}





main ()
{
  #for ROOT_DIRS in $ROOT_DIR*;
    # do	
	#if [ -d $ROOT_DIRS ]
         #then
        	print_warn "$ROOT_DIR"
       		dive_dir $ROOT_DIR
         #fi
     #done
}



##
## execute
##
main 

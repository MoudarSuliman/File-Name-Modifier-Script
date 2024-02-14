#!/bin/bash

# function to print usage information
usage() {
  echo "Usage: modify [-r] [-l|-u] <dir/file names...>"
  echo "       modify [-r] <sed pattern> <dir/file names...>"
  echo "       modify [-h]"
  echo ""
  echo "Options:"
  echo "  -r      operate on directories and their contents recursively"
  echo "  -l      convert file names to lowercase"
  echo "  -u      convert file names to uppercase"
  echo "  -h      print this usage information"
}


Uppercase()
{
for files in $@
do
    if [ -f $files ]
    then
        fname=${files%.*}  
        ext=${files##*.}
        
        echo "Modifying file $files..." 
        filename=$(echo "$fname" | tr '[:lower:]' '[:upper:]')
        modify=$filename.$ext
        
        if [ -e "$modify" ]
        then
            echo "The file $modify already exists!"
        else
            mv "$files" "$modify"
        fi
    else
        echo "The file is unknown!"
    fi
    shift
done
}

Lowercase()
{
for files in $@
do
    if [ -f $files ]
    then
        fname=${files%.*}  
        ext=${files##*.}
        
        echo "Modifying file $files..." 
        filename=$(echo "$fname" | tr '[:upper:]' '[:lower:]')
        modify=$filename.$ext
        
        if [ -e "$modify" ]
        then
            echo "The file $modify already exists!"
        else
            mv "$files" "$modify"
        fi
    else
        echo "The file is unknown!"
    fi
    shift
done
}

SedPattern()
{
    sed_pattern=$1
    shift
    for files in $@
    do
        if [ -f $files ]
        then
            fname=${files%.*}
            ext=${files##*.}
            filename=$(echo "$files" | sed -e $sed_pattern)
            modify=$filename
            echo "Modifying file $files..." 
            if [ -e "$modify" ]
            then
                echo "The file $modify already exists!"
            else
                mv "$files" "$modify"
            fi
        elif [ -d $files ]
        then
            cd $files
            echo "Modifying files inside directory $files..."
            for files in *
            do
                if [ -f "$files" ]
                then
                    fname=${files%.*}  
                    ext=${files##*.}
                    
                    echo "Modifying file $files..." 
                    filename=$(echo "$files" | sed -e $sed_pattern)
                    modify=$filename
                    
                    if [ -e "$modify" ]
                    then
                        echo "The file $modify already exists!"
                    else
                        mv "$files" "$modify"
                    fi
                fi
                if [ -d "$files" ]
                then
                    SedPattern "$sed_pattern" "$files"
                fi
            done
            
            cd .. 
        elif [[ "$files" == s/* ]]
        then
            echo "Sed pattern used is $files"
        else
            echo "Invalid file/directory"
        fi
        shift
    done
}

Recursion()
{
for dir in $@
do
    if [ $u = "y" ]
    then
        if [ -d $dir ]
        then
            #Change directory name as well
            # echo "Modifying directory name $dir..." 
            # dirname=$(echo "$dir" | tr '[:lower:]' '[:upper:]')
            # modify_dir=$dirname
            
            # if [ -e "$modify_dir" ]
            # then
            #     echo "The directory $modify_dir already exists!"
            # else
            #     mv "$dir" "$modify_dir"
            # fi
            
            echo "Modifying files inside directory $dir..."
            cd $dir
            
            
            for files in *
            do
                if [ -f "$files" ]
                then
                    fname=${files%.*}  
                    ext=${files##*.}
                    
                    echo "Modifying file $files..." 
                    filename=$(echo "$fname" | tr '[:lower:]' '[:upper:]')
                    modify=$filename.$ext
                    
                    if [ -e "$modify" ]
                    then
                        echo "The file $modify already exists!"
                    else
                        mv "$files" "$modify"
                    fi
                fi
                if [ -d "$files" ]
                then
                    Recursion "$files"
                fi
            done
            
            cd ..
        elif [ -f $dir ]
        then
        
            Uppercase "$dir"
        else
            echo "Directory/File $dir does not exist!"
        fi
    elif [ $l = "y" ]
    then
        if [ -d $dir ]
        then
            #Change directory as well

            # echo "Modifying directory name $dir..." 
            # dirname=$(echo "$dir" | tr '[:upper:]' '[:lower:]')
            # modify_dir=$dirname
            
            # if [ -e "$modify_dir" ]
            # then
            #     echo "The directory $modify_dir already exists!"
            # else
            #     mv "$dir" "$modify_dir"
            # fi
            
            echo "Modifying files inside directory $dir..."
            cd $dir
            
            
            for files in *
            do
                if [ -f "$files" ]
                then
                    fname=${files%.*}  
                    ext=${files##*.}
                    
                    echo "Modifying file $files..." 
                    filename=$(echo "$fname" | tr '[:upper:]' '[:lower:]')
                    modify=$filename.$ext
                    
                    if [ -e "$modify" ]
                    then
                        echo "The file $modify already exists!"
                    else
                        mv "$files" "$modify"
                    fi
                fi
                if [ -d "$files" ]
                then
                    Recursion "$files"
                fi
            done
            
            cd ..
        elif [ -f $dir ]
        then
            Lowercase "$dir"
        else
            echo "Directory/File $dir does not exist!"
    fi
    elif [[ "$1" == s/* ]]
    then
        SedPattern "$1" "$dir"
    else
    echo "Invalid file/directory called $dir"
    fi
done
}


u=n
l=n
r=n
s=n
while test "x$1" != "x"
do
        case "$1" in
                -u) u=y;;
                -l) l=y;;
                -r) r=y;;
                -s) s=y;;
                -h) h=y;;
                -*) error_msg "bad option $1"; exit 1 ;;
                *) break
        esac
        shift
done
if  [ $r = "y" ]
then
    Recursion $@
    exit 0
elif test $u = "y"
then
    Uppercase $@
elif test $l = "y"
then
    Lowercase $@
elif test $h = "y" 
then
    usage
    exit 1
else
    error_msg "no option provided"
    exit 1
fi
#!/usr/bin/env bash
echo "Running"
startingDirectory="${0%/*}"
subDirectories=()

remove_from_dirs() {
    toRemove="${1}"
    subDirectories=( ${subDirectories[@]/$toRemove/} )
}

run_rename() {
    dirsToCheck="${*}"

    for directory in ${dirsToCheck[@]}; do
        echo "--------- Checking ${directory} ----------"
        cd ${directory}
        IFS=$'\n'
        filesInDir=(*)
        echo ${filesInDir[@]}

        for file in ${filesInDir[@]}; do
            fileNameNoExt=${file%.*}
            fileExt=${file##*.}

            if [[ $file == $fileNameNoExt ]]; then
                echo "${file} is a directory"
                subDirectories+=(${file})
                continue;
            fi

            if [[ $fileNameNoExt != *"."* ]]; then
                echo "${file} is fine"
                continue;
            fi

            newFileName=${fileNameNoExt//./-}

            echo -n "Confirm change: ${fileNameNoExt} to: ${newFileName} [y/n]: "
            read ans

            if [[ $ans =~ ^[Yy]$ ]]
            then
                echo "Changing: ${file} to: ${newFileName}.${fileExt}"
                mv ${file} ${newFileName}.${fileExt}
                echo "rename done"
            fi
        done

        if [[ "${directory}" != "${startingDirectory}" ]]
            then
#            remove_from_dirs $directory
            cd ..
        fi
    done
}

run_rename "${startingDirectory}"

echo " here ${#subDirectories[@]} end "

#while [[ ${#subDirectories[@]} > 0 ]]; do
    run_rename "${subDirectories[@]}"
#done

echo ${subDirectories[@]}


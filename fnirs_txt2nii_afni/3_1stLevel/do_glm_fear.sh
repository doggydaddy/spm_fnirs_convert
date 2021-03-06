#!/bin/bash
file_dir=$1
files=`find $file_dir -name "*.nii" | grep fear` 

for i in $files; do
    file_name=$i
    echo "processing file: " $file_name
    # copying files to current folder
    cp $file_name . 
    cp ${file_name%.nii}.glm1 . 
    cp ${file_name%.nii}.glm2 . 

    # decompose file with path into its functional parts
    x=$file_name
    x_path=${x%/*} 
    x_base=${x##*/}
    x_fext=${x_base##*.}
    x_pref=${x_base%.*}

    3dDeconvolve -input ${x_pref}.nii -nfirst 0 -polort 4 \
                 -num_stimts 2 \
                 -stim_file 1 ${x_pref}.glm1 -stim_label 1 feel \
                 -stim_file 2 ${x_pref}.glm2 -stim_label 2 supp \
                 -num_glt 4 \
                 -gltsym 'SYM: +feel' -glt_label 1 feel-rest \
                 -gltsym 'SYM: +supp' -glt_label 2 supp-rest \
                 -gltsym 'SYM: +supp -feel' -glt_label 3 supp-feel \
                 -gltsym 'SYM: +supp +feel' -glt_label 4 task-rest \
                 -tout -bout \
                 -bucket stat_${x_pref}_fear.nii

    rm $x_base $x_pref.glm1 $x_pref.glm2
done
rm *.REML_cmd *.xmat.1D


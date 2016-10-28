for path in sheep alpaca polar_ursus cow cat dog panda; do
    cd $path
    bash run_align.sh
    cd ..
done

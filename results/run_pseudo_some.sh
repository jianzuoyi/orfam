for path in cow sheep horse cat orangutan marmoset guinea rabbit; do
    cd $path
    bash run_pseudo.sh
    cd ..
done

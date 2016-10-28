# modify the sequence names
bioawk -c fastx '{print ">AmOR."++n"\n"$2}' 608_intact.fa | sed 's/*//g' > panda_intact.fa
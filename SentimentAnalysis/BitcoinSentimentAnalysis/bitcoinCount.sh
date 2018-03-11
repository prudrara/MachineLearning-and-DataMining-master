for ((i=1;i<=6;i++)) ; 
  do for ((j=1;j<=12;j++)) ;
    do echo "201${i}-0${j}-01" >> bitcoinPopularity1.txt | python Exporter.py --querysearch "bitcoin" --since 201${i}-0${j}-01 --until 201${i}-0${j}-02 >> bitcoinPopularity1.txt ;
  done
done

for ((j=1;j<=8;j++)) ;
  do echo "2017-0${j}-01" >> bitcoinPopularity1.txt | python Exporter.py --querysearch "bitcoin" --since 2017-0${j}-01 --until 2017-0${j}-02 >> bitcoinPopularity1.txt ;
done


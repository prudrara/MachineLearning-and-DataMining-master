for ((i=17;i<=21;i++)) ; 
  #do for ((j=1;j<=12;j++)) ;
  #done
  do python Exporter.py --querysearch "bitcoin" --since 2017-08-${i} --until 2017-08-${i+1} --maxtweets 100 >> bitcoinTweets_${i}.txt;

done

#for ((j=1;j<=8;j++)) ;
#  do echo "2017-0${j}-01" >> bitcoinPopularity1.txt | python Exporter.py --querysearch "bitcoin" --since 2017-0${j}-01 --until 2017-0${j}-02 >> bitcoinPopularity1.txt ;
#done


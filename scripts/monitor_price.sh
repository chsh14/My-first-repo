#!/bin/bash -e 

URL=(http://www.adidas.no/terrex-swift-r-mid-gtx-shoes/BA9943.html http://www.adidas.no/street-graphic-crew-sweatshirt/BP8914.html)

for i in ${URL[@]}; do
    #echo "looking for $i"
    sale_price=$(curl -s "$i" | perl -nle 'print for m:data-sale-price=\"(.*)\"\s:')
    standard_price_exists=$(curl -s "$i" | perl -nle 'print for m:data-standard-price=\"(.*)\":')
    #echo "standard_price_exists = ${standard_price_exists}"
    if [ ! -z ${standard_price_exists} ]; then
        standard_price=$(curl -s "$i" | perl -nle 'print for m:data-standard-price=\"(.*)\":') 
        echo "$i is on SALE right now!!"
        echo "item : $i , sale_price : $sale_price , standard_price : $standard_price " | mail -s "[chsh] SALE notification service " "chirayu.shah14@gmail.com" 
        #send email about the sale
    else
        echo "Current price for $i :  ${sale_price}"
    fi



done



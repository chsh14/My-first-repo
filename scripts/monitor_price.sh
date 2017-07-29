#!/bin/bash -e

URL_adidas=(http://www.adidas.no/terrex-swift-r-mid-gtx-shoes/BA9943.html http://www.adidas.com/us/terrex-swift-r-gtx-shoes/BZ0605.html)
URL_nike=(https://store.nike.com/no/en_gb/pd/dry-academy-1-4-zip-football-drill-top/pid-11113012/pgid-11543879 https://store.nike.com/us/en_us/pd/dry-academy-mens-1-4-zip-soccer-drill-top/pid-11316902/pgid-11896250 https://store.nike.com/us/en_us/pd/air-max-infuriate-low-mens-basketball-shoe/pid-11596020/pgid-11621631)



check_adidas() {
    i=$1
    printCust "Checking $i"
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

}

check_nike() {
    i=$1
    printCust "checking $i"
    is_on_sale=$(curl -s "$i" | perl -nle 'print for m:span class.*product-on-sale:')
    price=$(curl -s "$i" | perl -nle 'print for m:product\:price\:am.*content=\"(.*)\":')
    #echo "price: $price"
    if [[ ${is_on_sale} == 1 ]]; then
        standard_price=$(curl -s "$i" | perl -nle 'print for m:overridden-local-price.*>(.*)<:')
        echo "$i is on SALE right now!!"
        echo "item : $i , sale_price : $price , standard_price : $standard_price " | mail -s "[chsh] SALE notification service " "chirayu.shah14@gmail.com"
    else
        echo "Current price of $i: ${price}"
    fi

}

printCust () {

 echo "----------------------------------------------------------"
 printf "%s\n" "$1"
 echo "----------------------------------------------------------"


}

#for z in ${URL_adidas[@]}
#do
#    for y in ${URL_nike[@]}
#    do
#        URL[i++]="$z:$y"
#    done
#done

URL+=("${URL_adidas[@]}" "${URL_nike[@]}")
#declare -p URL

for i in ${URL[@]}; do
    #echo "looking for $i"
    if [[ "$i" =~ .*nike\.com.* ]]; then
        #echo "its nike : $i"
        check_nike $i
    else
        #echo "its adidas : $1"
        check_adidas $i
    fi

done

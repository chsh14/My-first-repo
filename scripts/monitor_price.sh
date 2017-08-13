#!/bin/bash -e

URL_adidas=(http://www.adidas.no/terrex-swift-r-mid-gtx-shoes/BA9943.html)
URL_nike=(https://store.nike.com/no/en_gb/pd/dry-academy-1-4-zip-football-drill-top/pid-11113012/pgid-11543879 https://store.nike.com/us/en_us/pd/air-max-infuriate-low-mens-basketball-shoe/pid-11596020/pgid-11621631 https://store.nike.com/us/en_us/pd/air-max-infuriate-mid-mens-basketball-shoe/pid-11833469/pgid-11937991 https://store.nike.com/us/en_us/pd/dry-academy-mens-1-4-zip-soccer-drill-top/pid-11316902/pgid-12229191 https://store.nike.com/us/en_us/pd/dry-academy-mens-soccer-top/pid-11181846/pgid-11455365 https://store.nike.com/us/en_us/pd/dri-fit-knit-mens-long-sleeve-running-top/pid-11525483/pgid-11463528 https://store.nike.com/us/en_us/pd/dri-fit-cushion-crew-training-socks-large-6-pair/pid-10032697/pgid-11042787)



check_adidas() {
    i=$1
    printCust "Checking $i"    
    sale_price=$(curl  --connect-timeout 120 -s "$i" | perl -nle 'print for m:data-sale-price=\"(.*)\"\s:')
    standard_price_exists=$(curl  -s "$i" --connect-timeout 120 | perl -nle 'print for m:data-standard-price=\"(.*)\":')
    #echo "standard_price_exists = ${standard_price_exists}"
    if [ ! -z ${standard_price_exists} ]; then
        standard_price=$(curl -s "$i" | perl -nle 'print for m:data-standard-price=\"(.*)\":')
        echo "$i is on SALE right now!!"
        
        echo "item : $i , sale_price : $sale_price , standard_price : $standard_price " | mail -s "[chsh] SALE notification service " "chirayu.shah14@gmail.com"
        #send email about the sale
    elif [[ ${sale_price} == "" ]]; then
        echo "Item returned null.. Doesnt exist anymore" | mail -s "[chsh] SALE notification service " "chirayu.shah14@gmail.com"
    else
        echo "Current price for $i :  ${sale_price}"
    fi

}

check_nike() {
    i=$1
    printCust "checking $i"
    price=$(curl --connect-timeout 120 -s "$i"  | perl -nle 'print for m:product\:price\:am.*content=\"(.*)\":')
    #echo "$price"
    is_on_sale=$(curl -s "$i" | perl -nle 'print for m:span class.*product-on-sale:')    
    #status=$?
    #echo "$is_on_sale , $status"
    #echo "price: $price"
    if [[ ${is_on_sale} == 1 ]]; then
        standard_price=$(curl -s "$i" | perl -nle 'print for m:overridden-local-price.*>(.*)<:')
        echo "$i is on SALE right now!!"
        echo "item : $i , sale_price : $price , standard_price : $standard_price " | mail -s "[chsh] SALE notification service " "chirayu.shah14@gmail.com"
    elif [[  x${price} == "x" ]]; then
        echo "Price Not exists.. removed?"
        echo "Item returned null.. Doesnt exist anymore" | mail -s "[chsh] SALE notification service " "chirayu.shah14@gmail.com"
    else         
        echo "Current price of $i: ${price}"
    fi

}


check_global_sale() {
    nike_us=https://www.nike.com/us/en_us/
    nike_no=https://www.nike.com/no/en_gb/
    levi_us=http://www.levi.com/US/en_US/
    global_us_sale_exists=$(curl -s "${nike_us}" | grep -ci "headline.*sale")
    global_levi_sale_exists=$(curl -s "${nike_us}" | pcregrep -cM 'promodetail.*\n.*bullet-banner.*\n.*span.*sale')
    global_no_sale=$(curl -s "${nike_no}" | grep -ci "headline.*sale")
    if [[ $global_us_sale_exists > 0 ]]; then
        content=$(curl -s "${nike_us}" | grep -i "headline.*sale")
        printCust "${nike_us}:""\n""$content" 
    else
        echo "No sale found"
    fi
    
    if [[ $global_no_sale > 0 ]]; then
        content=$(curl -s "${nike_no}" | grep -i "headline.*sale")
        printCust "Nike content: \n $content"
    else
        printCust "${nike_no} No sale found.."
    fi

    if [[ $global_levi_sale_exists > 0 ]]; then
        content=$(curl -s "${levi_us}" | pcregrep -M 'promodetail.*\n.*bullet-banner.*\n.*span.*sale')
        printCust "Levi content: \n $content"
    else
        printCust "${levi_us} No sale found.."
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

URL=("${URL_adidas[@]}" "${URL_nike[@]}")
#declare -p URL
check_global_sale
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

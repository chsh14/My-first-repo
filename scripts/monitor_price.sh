#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

URL_adidas=()
URL_nike=(https://store.nike.com/us/en_us/pd/dri-fit-cushion-crew-training-socks-large-6-pair/pid-10032697/pgid-11042787 https://www.nike.com/t/element-mens-long-sleeve-half-zip-running-top-olTWJYob/857820-497)



#-------------------------------------------------------------------------------
# check for the adidas items
#-------------------------------------------------------------------------------
check_adidas() {
    i=$1
    #printCust "Checking $i"
    sale_price=$(curl  --connect-timeout 120 -s "$i" | perl -nle 'print for m:data-sale-price=\"(.*)\"\s:')
    standard_price_exists=$(curl  -s "$i" --connect-timeout 120 | perl -nle 'print for m:data-standard-price=\"(.*)\":')
    #echo "standard_price_exists = ${standard_price_exists}"
    if [ ! -z ${standard_price_exists} ]; then
        standard_price=$(curl -s "$i" | perl -nle 'print for m:data-standard-price=\"(.*)\":')
        echo "$i is on SALE right now!!"

        echo "item : $i , sale_price : $sale_price , standard_price : $standard_price " | mail -s "[chsh] SALE notification service " chirayu.shah14@gmail.com
        #send email about the sale
    elif [[ ${sale_price} == "" ]]; then
        echo "$i : Item returned null.. Doesnt exist anymore" | mail -s "[chsh] SALE notification service " chirayu.shah14@gmail.com
    else
        echo "Current price for $i :  ${sale_price}"
    fi

}

#-------------------------------------------------------------------------------
# check for nike items
#-------------------------------------------------------------------------------
check_nike() {
    i=$1
    #printCust "checking $i"
    price=$(curl --connect-timeout 120 -sL "$i"  | perl -nle 'print for m:product\:price\:am.*content=\"(.*)\":')
    #echo "$price"
    is_on_sale=$(curl -sL "$i" | perl -nle 'print for m:span class.*product-on-sale:')
    #status=$?
    #echo "$is_on_sale , $status"
    #echo "price: $price"
    if [[ ${is_on_sale} == 1 ]]; then
        standard_price=$(curl -sL "$i" | perl -nle 'print for m:overridden-local-price.*>(.*)<:')
        echo "$i is on SALE right now!!"
        echo "item : $i , sale_price : $price , standard_price : $standard_price " | mail -s "[chsh] SALE notification service " chirayu.shah14@gmail.com
    elif [[  x${price} == "x" ]]; then
        echo "$i: Price Not exists.. removed?"
        echo "$i: Item returned null.. Doesnt exist anymore" | mail -s "[chsh] SALE notification service " chirayu.shah14@gmail.com
    else
        echo "Current price of $i: ${price}"
    fi

}


check_global_sale() {
    nike_us=https://www.nike.com/us/en_us/c/men
    levi_us=http://www.levi.com/US/en_US/
    adidas_us=http://www.adidas.com/us/men-outdoor-shoes
    global_us_sale_exists=$(curl -s "${nike_us}" | grep -ciP "headline.*(sale|extra)")
    #echo "1"
    global_levi_sale_exists=$(curl -s "${levi_us}" | pcregrep -ciM 'promodetail.*\n.*bullet-banner.*\n.*span.*')
    #echo "2"
    #echo "3"
    global_adidas_sale=$(curl  --connect-timeout 120 -sL "${adidas_us}" | grep -ci "callout-overlay-content" )
    #echo "4"


    check_sale $nike_us $global_us_sale_exists 0 "grep -iP \"headline.*(sale|extra)\""

    #check_sale $nike_no $global_no_sale 0 "grep -iP \"headline.*(sale|extra)\""

    check_sale $levi_us $global_levi_sale_exists 1 "pcregrep -iM 'promodetail.*\n.*bullet-banner.*\n.*span.*'"

    check_sale $adidas_us $global_adidas_sale 4 "grep -iP \"callout-overlay-content\""

    #if [[ $global_us_sale_exists > 0 ]]; then
    #    content=$(curl -s "${nike_us}" | grep -i "headline.*sale")
    #    printCust "${nike_us}:""\n""$content"
    #else
    #    printCust "${nike_us} No sale found"
    #fi

    #if [[ $global_no_sale > 0 ]]; then
    #    content=$(curl -s "${nike_no}" | grep -i "headline.*sale")
    #    printCust "Nike content: \n $content"
    #else
    #    printCust "${nike_no} No sale found.."
    #fi

    #if [[ $global_levi_sale_exists > 0 ]]; then
    #    content=$(curl -s "${levi_us}" | pcregrep -M 'promodetail.*\n.*bullet-banner.*\n.*span.*promo')
    #    printCust "Levi content: \n $content"
    #else
    #    printCust "${levi_us} No sale found.."
    #fi

    #if [[ $global_adidas_sale > 6 ]]; then
    #    content=$(curl -s "${adidas_no}" | grep -i "callout-overlay-content")
    #    printCust "Adidas content: \n $content"
    #else
    #    printCust "${adidas_no} No sale found.."
    #fi

}


check_sale () {
    site_name=$1
    search_variable=$2
    search_var_cnt=$3
    search_string=$4
    #echo "search_variable: $search_variable,  search_var_cnt : $search_var_cnt"
    #echo "search_string $search_string"
    command="curl -sL $site_name | ${search_string}"
    #echo "$command"
    if [[ $search_variable > ${search_var_cnt}  ]]; then
        content=$(eval "$command")
        #content=$(curl -s "${site_name}" | grep -i "${search_string}")
        echo "${site_name}: \n $content" | mail -s "[chsh] SALE notification service " chirayu.shah14@gmail.com
    else
        printCust "${site_name} : No sale found"
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

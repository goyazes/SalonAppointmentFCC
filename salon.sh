#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"


#SERVICE_ID="$($PSQL "SELECT service_id,name FROM services")"

#SERVICE_NAME="$($PSQL "SELECT name FROM services WHERE service_id)"

#total de serviços na tabela services
TOTAL="$($PSQL "SELECT COUNT(*) FROM services" )"
#SERVICE_NAME="$($PSQL "SELECT name FROM services WHERE service_id = $INC")"
#SERVICE_ID="$($PSQL "SELECT service_id FROM services where service_id=$INC")"
ARG=""
INPUT_PHONE=""
INPUT_NAME=""
INPUT_TIME=""

#Contador
FUN() {
INC=1
while [[ $INC -le $TOTAL ]]
do
  SERVICE_NAME="$($PSQL "SELECT name FROM services WHERE service_id = $INC")"
  SERVICE_ID="$($PSQL "SELECT service_id FROM services where service_id=$INC")"
  echo "$SERVICE_ID) $SERVICE_NAME"
  #incrementa o contador
  INC=$((INC + 1))
done

read SERVICE_ID_SELECTED
ARG="$SERVICE_ID_SELECTED"
}
FUN

# regex do integer
re='^[0-9]+$'

#repete a tela se o input for maior que a lista, ou for diferente de um número.
while [[ $ARG -gt $TOTAL ]] || [[ ! $ARG =~ $re ]]
do
  FUN
done

echo "Whats your phone number?"
read CUSTOMER_PHONE
INPUT_PHONE="$CUSTOMER_PHONE"

NAME="$($PSQL "SELECT name FROM customers WHERE phone='$INPUT_PHONE'")"

if [[ -z $NAME ]];
  then
    echo "I don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INPUT_NAME="$CUSTOMER_NAME"

    SERVNAME="$($PSQL "SELECT name FROM services WHERE service_id = $ARG")"
    echo "What time would you like your $servName, $INPUT_NAME?"
    read SERVICE_TIME
    INPUT_TIME="$SERVICE_TIME"

      
      SIGN_CUSTOMER="$($PSQL "INSERT INTO customers(name, phone) VALUES('$INPUT_NAME','$INPUT_PHONE')")"
      GET_CUST="$($PSQL "SELECT customer_id FROM customers WHERE phone='$INPUT_PHONE' ")"
      SIGN_APPOINTMENT="$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUST, $ARG, '$INPUT_TIME')")"
    echo "I have put you down for a $SERVNAME at $INPUT_TIME, $INPUT_NAME."

  else

    SERVNAME="$($PSQL "SELECT name FROM services WHERE service_id = $ARG")"
    echo "What time would you like your $SERVNAME, $NAME?"
    read SERVICE_TIME
    INPUT_TIME="$SERVICE_TIME"

    GET_CUST="$($PSQL "SELECT customer_id FROM customers WHERE phone='$INPUT_PHONE' ")"
    SIGN_APPOINTMENT="$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($GET_CUST, $ARG, '$INPUT_TIME')")"
    
    echo "I have put you down for a $SERVNAME at $INPUT_TIME, $NAME."
  fi
exit
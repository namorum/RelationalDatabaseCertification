#! /bin/bash
PSQL="psql -t -U freecodecamp -d salon -c"

function SERVICE_PICK {
  SERVICES=$($PSQL "select * from services")
  echo -e "$SERVICES" | while read SERVICE_ID SEP NAME
  do
    echo -e "$SERVICE_ID) $NAME"
  done

  echo -e "\nEnter service id: "
  read SERVICE_ID_SELECTED 
  SERVIDE
  SERVICE_NAME=$($PSQL "select name from services where service_id=$SERVICE_ID_SELECTED")
  if [[ -z $SERVICE_NAME ]]
  then
    SERVICE_PICK
    return 0
  fi

  echo -e "\nEnter phone number: "
  read CUSTOMER_PHONE
  CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_ID ]]
  then
    echo -e "\nEnter your name: "
    read CUSTOMER_NAME
    INSERT_RESULT=$($PSQL "insert into customers(phone, name) values('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
  fi

  echo -e "\nEnter time: "
  read SERVICE_TIME
  INSERT_RESULT=$($PSQL "insert into appointments(customer_id, service_id, time) values($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
}

SERVICE_PICK


#! /usr/bin/bash


PSQL="psql --username=freecodecamp --dbname=periodic_table -t --csv -c"
SELECT="select atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius"
FROM="from elements left join properties using(atomic_number) left join types using(type_id)"

#echo "GOAL" | read NUMBER
#echo -e "1\nHydrogen\nH\nnonmetal\n1.008\n-259.1\n-252.9" | read NUMBER NAME SYMBOL TYPE MASS MELT BOIL
#echo $NUMBER #$NAME $SYMBOL $TYPE $MASS $MELT $BOIL

#$PSQL "$SELECT $FROM" | sed 's/|/ /g' 


if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
else
  if [[ $1 =~ [0-9]+ ]]
  then
    RESULT="$($PSQL "$SELECT $FROM where atomic_number = $1")"
  elif [[ $1 =~ ^[A-Z][a-z]?$ ]]
  then
    RESULT="$($PSQL "$SELECT $FROM where symbol = '$1'")"
  else
    RESULT="$($PSQL "$SELECT $FROM where name = '$1'")"
  fi
  if [[ -z $RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    IFS="," read NUMBER NAME SYMBOL TYPE MASS MELT BOIL <<< $RESULT
    echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
  fi
fi

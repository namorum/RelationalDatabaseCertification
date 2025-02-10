#!/bin/bash
PSQL="psql -U freecodecamp -d number_guess -t --csv -c"

echo "Enter your username: "
read NAME

USER_ID=$($PSQL "select user_id from users where name = '$NAME'")

# Welcoming
if [[ -z $USER_ID ]] ; then
  INSERT=$($PSQL "insert into users(name) values('$NAME')")
  USER_ID=$($PSQL "select user_id from users where name = '$NAME'")
  echo Welcome, $NAME! It looks like this is your first time here.
else
  GAMES_COUNT=$($PSQL "select count(*) from games where user_id = $USER_ID")
  BEST_GUESS=$($PSQL "select number_of_guesses from games where user_id = $USER_ID order by number_of_guesses limit 1")
  echo Welcome back, $NAME! You have played $GAMES_COUNT games, and your best game took $BEST_GUESS guesses.
fi

# Number guessing
SECRET=$(($RANDOM%1000+1))
GUESS_NUMBER=1
echo "Guess the secret number between 1 and 1000: "
read GUESS
while [[ $GUESS -ne $SECRET ]] ; do
  if [[ ! $GUESS =~ -?[0-9]+ ]] ; then
    echo "That is not an integer, guess again:"
  else
    ((GUESS_NUMBER++))
    if [[ $GUESS -lt $SECRET ]]; then
      echo "It's higher than that, guess again: "
    else
      echo "It's lower than that, guess again: "
    fi
  fi
  read GUESS
done

INSERT=$($PSQL "insert into games(user_id, number_of_guesses) values($USER_ID, $GUESS_NUMBER)")
echo "You guessed it in $GUESS_NUMBER tries. The secret number was $SECRET. Nice job!"
#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table --tuples-only -c"



 if [[ -z $1 ]]
 then
  echo "Please provide an element as an argument."
  exit 0
  else
    USER_SELECTION=$1
  fi

if [[ ! $USER_SELECTION =~ ^[0-9]+$ ]]
then
  
  SYMBOLS=$($PSQL "SELECT symbol FROM elements WHERE LOWER(symbol)=LOWER('$USER_SELECTION')")
  NAMES=$($PSQL "SELECT name FROM elements WHERE LOWER(name)=LOWER('$USER_SELECTION')")
  if [[ -z $SYMBOLS ]]
  then
    if [[ -z $NAMES ]]
    then
      echo "I could not find that element in the database."
    else
      ELEMENT_PICKED=$($PSQL "SELECT * FROM elements WHERE LOWER(name)=LOWER('$USER_SELECTION')")
      PROPERTIES_PICKED=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=(SELECT atomic_number FROM elements WHERE LOWER(name)=LOWER('$USER_SELECTION'))")
      TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=(SELECT atomic_number FROM elements WHERE LOWER(name)=LOWER('$USER_SELECTION'))")
      TYPE=$($PSQL "SELECT type FROM types WHERE type_id='$TYPE_ID'")
      echo "$ELEMENT_PICKED $PROPERTIES_PICKED" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a$TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
      done
    fi
  else
    ELEMENT_PICKED=$($PSQL "SELECT * FROM elements WHERE LOWER(symbol)=LOWER('$USER_SELECTION')")
    PROPERTIES_PICKED=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number=(SELECT atomic_number FROM elements WHERE LOWER(symbol)=LOWER('$USER_SELECTION'))")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number=(SELECT atomic_number FROM elements WHERE LOWER(symbol)=LOWER('$USER_SELECTION'))")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id='$TYPE_ID'")
    echo "$ELEMENT_PICKED $PROPERTIES_PICKED" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a$TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
else
  ATOMIC_NUMB=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$USER_SELECTION ORDER BY atomic_number;")
  if [[ -z $ATOMIC_NUMB ]]
  then
    echo "I could not find that element in the database."
  else
    ELEMENT_PICKED=$($PSQL "SELECT * FROM elements WHERE atomic_number='$USER_SELECTION'")
    PROPERTIES_PICKED=$($PSQL "SELECT atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number='$USER_SELECTION'")
    TYPE_ID=$($PSQL "SELECT type_id FROM properties WHERE atomic_number='$USER_SELECTION'")
    TYPE=$($PSQL "SELECT type FROM types WHERE type_id='$TYPE_ID'")
    echo "$ELEMENT_PICKED $PROPERTIES_PICKED" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME ATOMIC_MASS BAR MELTING_POINT_CELSIUS BAR BOILING_POINT_CELSIUS
    do
      echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a$TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_CELSIUS celsius and a boiling point of $BOILING_POINT_CELSIUS celsius."
    done
  fi
fi






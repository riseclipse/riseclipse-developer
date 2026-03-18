#!/bin/sh

# Exit on error
set -e

# Trap SIGINT (Ctrl+C) and exit the script
trap 'echo -e "\nScript interrupted. Exiting..."; exit 130' SIGINT

GOALS=$*

cd ../riseclipse-developer
mvn $GOALS
cd ../riseclipse-developer/fr.centralesupelec.edf.riseclipse.developer.p2_to_m2
mvn $GOALS
cd ..
cd ../riseclipse-main
mvn $GOALS
cd ../riseclipse-editor
mvn $GOALS
cd ../riseclipse-validator-ocl
mvn $GOALS
cd ../riseclipse-metamodel-scl2003
mvn $GOALS
cd ../riseclipse-metamodel-nsd2016
mvn $GOALS
cd ../riseclipse-metamodel-cim
mvn $GOALS
cd ../riseclipse-metamodel-cgmes-3-0-0
mvn $GOALS
cd ../riseclipse-validator-scl2003
mvn $GOALS
cd ../riseclipse-validator-cgmes-3-0-0
mvn $GOALS
cd ../riseclipse-distribution
mvn $GOALS
mvn -Pupdate-site $GOALS
mvn -Prcp $GOALS

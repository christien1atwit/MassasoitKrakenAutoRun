#!/bin/bash

#Kraken Bioinformatics Auto Script V1
#Nathan Christie
#July 10th 2025

#Created for Massasoit STEM

#Operation: Place folders with FastQ files into the 'queue' directory and run this script.
#Output: Identified datasets will be placed into the 'out' directory. Logs of the Kraken2 run will bb placed into the 'log' directory. The folders with the FastQ files will be moved from 'queue' to 'archive' after processing.

#ADD THIS SCRIPT TO CRON JOB LIST TO AUTOMATE. (This is set currently, and this will run every 5 minutes)
#This file can also be run directly through the shell


#This is the path to the bioinformatics database used for identifying sequences
kDatabase="/home/jmyrtil/k2_pluspfp_16gb_20231009"

#This is the path to the Kraken2 program
kProgPath="/home/jmyrtil/apps/kraken2/kraken2"

#This iterates through the folders placed in the queue
for filename in $(dirname $BASH_SOURCE)/queue/*; do

    #Lists the FastQ files inside the folder the script is about to work on
    ls $filename
	
    #Stores name of the current folder of FastQ data that is being processed
    dataDirName=$(basename $filename)
    #===kraken2 run====
    $kProgPath --db $kDatabase $filename/* --confidence 0.0 --output $(dirname $BASH_SOURCE)/log/${dataDirName}_log.txt  --threads 16 --report $(dirname $BASH_SOURCE)/out/${dataDirName}_identified.txt
    #====================================
	
    #Copy the folder from the queue directory to the archive directory
    cp -r $filename $(dirname $BASH_SOURCE)/archive/$dataDirName
    #Remove the folder from the queue directory
    rm -r $filename
done

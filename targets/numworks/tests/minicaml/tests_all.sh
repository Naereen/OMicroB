#!/usr/bin/env bash

clear

for i in examples/*.mml; do
	echo $i
	./mmli.exe $i
done

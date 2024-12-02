#!/bin/bash

docker build --platform linux/arm/v7 -t bahricanli/docker-openmediavault:latest .

docker push bahricanli/docker-openmediavault


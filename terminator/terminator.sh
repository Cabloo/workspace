#!/bin/bash

cd "/home/zane/repos/tms/src";

case $1 in
    1)
        echo "Connecting to Vagrant via SSH..."
        vagrant up && vagrant ssh
    ;;
    2)
        echo "Connecting to production via SSH..."
        # TODO: Vagrant SSH
    ;;
    4)
        echo "Workspace initiated."
        atom .
    ;;
    *)

    ;;
esac

# Reinitiate interactive bash so that terminals stay
bash -i

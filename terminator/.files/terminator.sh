#!/bin/bash

cd {DIR}

case $1 in
    1)
        echo "Connecting to production via SSH...";
        #ssh root@someserver
    ;;
    2)
        echo "Connecting to production via SSH...";
        #ssh root@someserver
    ;;
    4)
        echo "Workspace initiated.";
        atom .
    ;;
    *)

    ;;
esac

# Reinitiate interactive bash so that terminals stay
bash -i

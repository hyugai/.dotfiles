#!/bin/bash

#
free -h | grep -i mem | awk '{printf " : %.1f%", $3 * 100 / $2 }'

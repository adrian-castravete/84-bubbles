#!/bin/bash

zip -9r 84-bubbles.`date +%Y%m%d%H%M`.love . -x*.swp -xage-project/* -x.git*

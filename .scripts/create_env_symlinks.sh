#!/bin/bash

cd ..

for dir in ./*; do (ln -fs ../default.env  "$dir/default.env"); done

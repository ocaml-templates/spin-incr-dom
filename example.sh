#!/bin/bash

set -xe

rm -rf example
SPIN_CREATE_SWITCH=false SPIN_PROJECT_NAME=Demo SPIN_SYNTAX=OCaml SPIN_PACKAGE_MANAGER=Opam spin new . example -d -vv

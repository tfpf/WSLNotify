#! /usr/bin/env sh

set -e

cargo --quiet build --features=bash
cargo --quiet build --features=zsh

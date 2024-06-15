#! /usr/bin/env sh

set -e

cargo --quiet build --features=bash --release
cargo --quiet build --features=zsh --release

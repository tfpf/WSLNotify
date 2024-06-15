#! /usr/bin/env sh

set -e

cargo --quiet build --release --features=bash
cargo --quiet build --release --features=zsh

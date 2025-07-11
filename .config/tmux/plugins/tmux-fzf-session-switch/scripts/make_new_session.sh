#!/usr/bin/env bash

SESSION_NAME=$1

function main {
  tmux new-session -d -s "$SESSION_NAME"
  tmux switch-client -t "$SESSION_NAME"
}
main

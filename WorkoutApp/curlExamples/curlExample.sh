#!/usr/bin/env bash


curl -k https://arcane-anchorage-34204.herokuapp.com/handleCode --data-binary '{"code":"FE4528C"}' -H "Content-Type:application/json" > curl1.out

curl -k https://arcane-anchorage-34204.herokuapp.com/handleCode --data-binary '{"code":"V27D758"}' -H "Content-Type:application/json" > curl2.out

curl -k https://arcane-anchorage-34204.herokuapp.com/handleCode --data-binary '{"code":"TSXB3PH"}' -H "Content-Type:application/json" > curl3.out

curl -k https://arcane-anchorage-34204.herokuapp.com/handleCode --data-binary '{"code":"WATEULR"}' -H "Content-Type:application/json" > curl4.out

curl -k https://arcane-anchorage-34204.herokuapp.com/handleCode --data-binary '{"code":"FE4528CBADCODE"}' -H "Content-Type:application/json" > bad.out


#!/bin/bash

clarinet console | (contract-call? .$1 $2)


" Vim syntax file for quickfix window
" Language: Quickfix List

if exists("b:current_syntax")
  finish
endif

" Highlight groups
syn match qfFileName       /^.\{-}\ze\s*│\s*\d\+:\d\+\s*│/
syn match qfLineCol        /│\s*\d\+:\d\+\s*│/ contains=qfLocation
syn match qfLocation       /\d\+:\d\+/ contained
syn match qfText           /│ \zs.*$/

" Color definitions
hi def link qfFileName     Directory
hi def link qfLineCol      Comment
hi def link qfLocation     Comment
hi def link qfText         Normal

let b:current_syntax = "qf"

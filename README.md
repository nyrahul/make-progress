# make progress

`make` does not report progress by itself. Some makes can take ages, for e.g.,
linux kernel make. This script helps to track elapsed time and get an estimate
for remaining time.

## How does it do it?

`make` provides an option `-n` wherein it simply lists the commands it will
execute (without actually executing it) to fulfill the job. The script tracks
these commands and gets the estimate.

## FAQs

1. Estimate increases suddenly at run-time for certain builds.
    Certain makefiles invoke shell commands which in turn adds more work for
    the default make. For e.g., certain makes invoke `./configure` for third
    party library which in turn generate additional work not anticipated during
    invocation.

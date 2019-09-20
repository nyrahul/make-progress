# Report make progress and estimate remaining time

`make` does not report progress by itself. Some makes can take ages, for e.g.,
linux kernel make. This script helps to track elapsed time and get an estimate
for remaining time. It does all this asynchronously. Just invoke
`make-progress.sh` from another shell (from the same user) and track the
`make` execution.

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

2. What if there are multiple makes from different folders?

    The script takes the oldest make in execution. Note that a make might spawn
    other makes, the script distinguishes between a make spawned from within
    make vs make invoked separately for another code base.

3. Does it work for non C/C++ code base?

    It should, but I not tested.

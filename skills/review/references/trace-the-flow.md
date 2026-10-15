# Tracing the flow, mapping it as you go

For each suspicious line, answer: what does a person do in the product to make
this line run? The diff and the files already open answer it most of the time,
and one step up to the caller answers the rest. Still unclear after that step?
Say so in the finding and move on. A path MUST NOT be invented, and callers
MUST NOT be chased beyond the first relevant caller.

Build the map while you read: what the person does, which changed file runs
next, what it does to the data and what that changes on screen. That is part 2
of the answer.

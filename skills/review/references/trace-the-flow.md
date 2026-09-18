# Tracing the flow, mapping it as you go

For each suspicious line, answer: what does a person do in the product to make
this line run? The diff and the files already open answer it most of the time,
and one step up to the caller answers the rest. Still unclear after that step?
Say so in the finding and move on. A path MUST NOT be invented, and chasing
callers across the repo waits for the deep dive.

Build the map while you read: which changed file calls which, what each is for,
which one carries the idea. That is part 2 of the answer.

# The deep dive

The four parts are the first pass, read off the diff. Digging into all of it
costs more than most of it is worth, so let the user spend that time where they
want it.

## The offer

The answer MUST close with the offer, in the report language, one choice per
finding plus three standing ones. Each finding choice MUST carry the same number
and the same short text as the findings table, so the user picks without
scrolling back.

The three standing choices MUST come last, in this order: all of them, post the
comments with no digging, and nothing more. The posting one jumps straight to
the posting step.

You MUST read [pick-lists.md](pick-lists.md) before writing the offer: how to
put the choices on screen, and why a markdown checkbox MUST NOT be used.

Over five findings? Give a choice to the blockers and the "should fix" ones, and
one choice for all the nits together.

## What digging means

The user picks? Then, for each finding named:

- Trace the callers up to a button, a page load, a job, an API request or a CLI
  command, and name the entry point.
- Pick the exact input that triggers it, read the code with that input in hand,
  and quote what comes out.
- The verdict still hangs on an answer reading can't give? Run the smallest
  piece that settles it, the way [getting-the-code.md](getting-the-code.md)
  says.
- Grep how often it happens in this repo today: a number, not a guess.
- It turns out it can't happen? Say the finding is dropped, and why.

Then reissue that finding whole, in the shape [finding-shape.md](finding-shape.md)
gives it, with its table row and its comment block. Same four headings, same
order. What changes is what they say: the evidence marker, the real value, the
count, and the severity when the answer moved it. A deep dived finding and a
first pass one MUST look the same on the page.

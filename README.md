# Noughts & Crosses
An unbeatable Tic-Tac-Toe (Noughts and Crosses) program.

- User can choose the game type (human v. computer, human v. human, or computer v. computer).
- The computer player should never lose and should win whenever possible.
- The user should also have the choice of which player goes first.

## Tests
`bundle exec rspec`

## Run
`ruby ./run.rb`. Enter moves in the form 'x, y'.

## Design & Lessons

My solution uses an implementation of minimax to calculate the ideal move.

I started out by putting aside the problem of calculating the ideal move, instead building a game that could be played Human vs Human. I think this was a mistake as when it came to implementing the minimax algorithm, I had the cognitive overhead working the algorithm into my existing design. The lesson I take from this is that it's often better to immediately set your sights on the essence of a problem, rather than come at it from the edges.

When I first added minimax, my test suite was taking upwards of 30 seconds to run, an intolerably long time. I realized, however, that on each branch it was continuing to crunch through possibilities even when a move with the maximum (or minimum) rank had already been found. When I solved this issue the test suite dropped to 10 seconds, better but still too long.

My second realization was that the algorithm was recalculating for scenarios that had already occurred on a previous branch. I implemented some caching, which brought the test suite down to 2 seconds. This strikes me as still a long time for such a small application without any IO. I imagine there are more sophisticated ways of optimizing the algorithm and I will continue to explore those.

## Issues
At the moment the computer ranks all scenarios that can't be forced by either party towards a victory as the same. In other words, the computer assumes that the opponent will always make the perfect move. Actually some scenarios invite more mistakes than others, even if from the perspective of the perfect player they are the same. The computer might perform better against a human player if it ranked moves with more granularity, perhaps taking into account the proportion of winning/losing scenarios coming off of a branch.

## Feedback
1. Game is really turn. Lots of untested logic in run.rb.
2. Game spec needn't repeatedly test that #nought_move / #cross_move works as expected.
4. require 'pry'
3. UX: How to enter a move? Where is 0, 0? Make more friendly
4. Testing run: separating the running of the game from the input/output.

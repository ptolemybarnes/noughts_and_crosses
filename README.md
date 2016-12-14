# Noughts & Crosses
An unbeatable Tic-Tac-Toe (Noughts and Crosses) program.

- User can choose the game type (human v. computer, human v. human, or computer v. computer).
- The computer player should never lose and should win whenever possible.
- The user should also have the choice of which player goes first.

# Design & Lessons

My solution uses an implementation of minimax to calculate the ideal move in noughts and crosses.

I started out by putting aside the problem of calculating the ideal move, instead building a game that could be played Human vs Human. I think this was a mistake as when it came to implementing the minimax algorithm, I had the cognitive overhead working the algorithm into my existing design. The lesson I take from this is that it's often better to immediately set your sights on the essence of a problem, rather than come at it from the edges.

When I first added minimax, my test suite was taking upwards of 30 seconds to run, an intolerably long time. I realized, however, that on each branch it was continuing to crunch through possibilities even when a move with the maximum (or minimum) rank had already been found. When I solved this issue the test suite dropped to 10 seconds, better but still too long.

My second realization was that the algorithm was repeatedly calculating for scenarios that had already occurred on a previous branch. I implemented some caching, which brought the test suite down to 2 seconds. This strikes me as still a long time for such a small application without any IO. I imagine there are more sophisticated ways of optimizing the algorithm and I will continue to explore those.

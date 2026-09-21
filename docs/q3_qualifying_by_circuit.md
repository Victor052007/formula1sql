# How much does qualifying matter at each circuit?

Query: [`queries/q3_qualifying_by_circuit.sql`](../queries/q3_qualifying_by_circuit.sql)

## Method

For each circuit, the average absolute difference between starting position (`grid`) and finishing position (`position`). A low value means the finishing order stayed close to the grid, so qualifying mattered more.

Filters: finishers only, no pit-lane starts (`grid > 0`), races from 2010 onwards, and only circuits with at least 100 results.

## Results

| Circuit | Avg. positions changed |
|---|---|
| Autódromo Hermanos Rodríguez | 2.59 |
| Circuit de Barcelona-Catalunya | 2.71 |
| Circuit de Monaco | 2.72 |
| Shanghai International Circuit | 2.73 |
| Yas Marina Circuit | 2.74 |
| Suzuka Circuit | 2.91 |
| Circuit of the Americas | 2.96 |
| Red Bull Ring | 2.97 |
| Autodromo Nazionale di Monza | 2.97 |
| Albert Park Grand Prix Circuit | 3.12 |
| Silverstone Circuit | 3.16 |
| Circuit Gilles Villeneuve | 3.16 |
| Hungaroring | 3.18 |
| Marina Bay Street Circuit | 3.21 |
| Bahrain International Circuit | 3.25 |
| Sochi Autodrom | 3.33 |
| Hockenheimring | 3.38 |
| Autódromo José Carlos Pace | 3.38 |
| Baku City Circuit | 3.40 |
| Circuit de Spa-Francorchamps | 3.44 |
| Sepang International Circuit | 3.99 |

## Why this question

We've all heard the myth that if you start first at Monaco you'll stay there for the entire race, while at Monza you'll be overtaken in the first corner. But is it statistically true?

## First issue I ran into

If you're a racing fan, you already know there is barely any overtaking at Monaco, yet it ended up around the middle of the leaderboard. How did that happen? The query counts positions gained or lost even when they come from other drivers retiring, so a driver can gain places without overtaking anyone. The circuits that "showed the most overtakes" were mostly from F1's early decades, when simply finishing a race was an achievement because half the grid retired.

## Second issue I ran into

I've watched F1 for a long time, yet I didn't recognize the circuits at the top and bottom of the leaderboard. How did that happen? The database includes every race ever held, so an average means little for a circuit that hosted only a few races compared to Monaco or Monza.

**Solution:** to exclude circuits without enough data, I set a minimum of 100 results. For a more useful conclusion, I also only included races from 2010 onwards.

## Unexpected conclusion

A large part of the circuits didn't land where I expected them on the leaderboard. How did that happen?

Spa, Baku and Sepang took the top of the leaderboard, which I didn't expect. The reason is the chaos in those races: Spa, Hockenheim, Sepang and Interlagos often have rain, while Baku often has a lot of safety cars.

Yas Marina ended up near the bottom. It was redesigned in 2021 to allow more overtaking, but my query averages 2010–2024 together, so it can't show whether the redesign worked. Splitting the results before and after 2021 would answer that.

So why does the leaderboard look different than expected? Right now, the query can't tell the difference between overtaking and gaining places because other drivers retired.

The most interesting thing to research is why Shanghai and Monza are so low, even though they have some of the longest straights on the calendar. Ironically, one of the main causes is the lack of events that create chaos: Monza is held in early September, so rain is relatively rare. Another reason might be that Monza has little variety in its corners, so the order is mostly decided in qualifying. A further factor on permanent circuits is the eras of domination by Mercedes and Red Bull, who usually started at the front, so very few overtakes were needed.

So why is Monza so close to Monaco in the numbers, yet feels so different? Few overtakes on two circuits doesn't mean overtaking is equally difficult. On high-speed permanent circuits like Monza, the finishing order often matches the grid, so very little overtaking is needed. On tight street circuits like Monaco, the few overtakes come from the fact that overtaking is physically difficult. The query can't see what a human sees and explain why the numbers look the same.

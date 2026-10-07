# Which driver really outperformed the car, measured against their teammate?

Query: [`queries/q2_teammates.sql`](../queries/q2_teammates.sql)

F1 has always had special drivers who got more out of a car than it was supposed to give. Just extracting everything a car has is already hard, so going beyond that is rare. But how do you measure it? Comparing finishing positions with other drivers is useless, because they are in different cars. My solution is to measure a driver against their teammate, since that is the only person on the grid with the same machinery.

## How I measured it

For every race I joined `results` to itself, matching rows from the same race and the same constructor but with a different driver. That puts a driver and their teammate on the same row, with both finishing positions next to each other.

From there I measure two things per driver per season:

- **win_rate** — the share of races where they finished ahead of their teammate
- **avg_gap** — the average number of positions between them

I only count races where both drivers finished, because a retirement says nothing about who was faster. I also set a minimum of 7 duels per season, so a substitute who raced twice doesn't end up at the top. Indianapolis is excluded (see below).

## Results

Perfect seasons — a driver who never lost a duel:

| Season | Driver | Duels | Win rate | Avg. gap |
|---|---|---|---|---|
| 1951 | Rosier | 14 | 1.00 | 2.36 |
| 1952 | Ascari | 23 | 1.00 | 4.96 |
| 1954 | Fangio | 12 | 1.00 | 3.75 |
| 1957 | Fangio | 24 | 1.00 | 5.17 |
| 1958 | Fangio | 9 | 1.00 | 3.67 |
| 1969 | Stewart | 8 | 1.00 | 3.38 |
| 1976 | Hunt | 8 | 1.00 | 5.13 |
| 1987 | Senna | 8 | 1.00 | 5.00 |
| 1992 | Mansell | 9 | 1.00 | 1.67 |
| 1997 | Schumacher | 9 | 1.00 | 4.67 |
| 2008 | Vettel | 10 | 1.00 | 6.20 |
| 2012 | Alonso | 17 | 1.00 | 5.35 |
| 2013 | Vettel | 15 | 1.00 | 3.13 |
| 2020 | Verstappen | 11 | 1.00 | 4.09 |
| 2021 | Verstappen | 17 | 1.00 | 5.06 |
| 2024 | Verstappen | 19 | 1.00 | 5.21 |

The list is mostly world champions, which is the best sign the metric measures something real. Fangio appears four times and Verstappen three.

The biggest single season is **Fangio 1957**: 24 duels, 24 wins, an average of 5.17 positions ahead. Nobody else combines that many duels with a perfect record.

## 2024 as a test case

I started with 2024 because I remember the season well enough to tell whether the numbers make sense.

- **Verstappen** won all 19 duels against Pérez, by an average of 5.21 positions. Pérez shows the exact mirror, 0 wins and −5.21, which is a good sign that the query is right.
- **Hülkenberg** beat Magnussen in 16 of 21 duels (0.76) in a midfield car. That is exactly the kind of driver this question is meant to find, since he scored almost nothing all season. **Sargeant** lost all 10 of his duels with Albon and was replaced during the season.
- The two big intra-team fights went one way each: **Norris** 0.67 over Piastri, and **Leclerc** 0.64 over Sainz.
- **Bottas** is the interesting case. He beat Zhou in 60% of the races, but his avg_gap is −0.25. He won often by a little and lost rarely by a lot. The two metrics disagree, which is exactly why I kept both.

## Problems with the old seasons

The old seasons break this metric, and Indianapolis is the problem again. The Indy 500 counted for the championship between 1950 and 1960, with 33 cars on the grid instead of 20, so the position gaps there don't compare with anything else. Excluding it (`circuit_ref != 'indianapolis'`) removes the American drivers who dominated the top of the ranking without ever racing anywhere else in the season.

F1 also worked differently back then. Teams didn't enter two drivers, they entered as many cars as they wanted, so one driver can have several teammates in the same race. That is why some drivers still show more duels than there were races in the season: Hawthorn has 28 in 1953, Peterson 26 in 1972. Excluding Indianapolis doesn't fix this, because it happened in ordinary Grands Prix too.

On top of that, drivers could share a car during a race, which is the same problem I already ran into with `results`.

## Limitations

- If both drivers outperform the car, or both underperform, nothing shows up. The metric only sees the difference between the two, never how good the car was.
- The two columns reward different things: `win_rate` rewards winning often, `avg_gap` rewards winning by a lot. A driver can look strong on one and weak on the other.
- The ranking can't be fair: beating the worst driver on the grid counts the same as beating prime Senna. The data doesn't know that one is a legend and the other a reserve driver, and I can't fix it without adding some kind of driver rating, which would then depend on who you beat.
- Even with the same car, teams don't treat both drivers equally. The clearest documented case is Ferrari in 2002, when Barrichello was told to let Schumacher past on the line in Austria, after which the FIA banned team orders. More often it is subtler: upgrades, strategy priority and the better pit window go to the lead driver. None of that is in the data, so I can't separate the driver from the treatment.
- The 7-duel minimum is a fixed number across all eras. In a 24-race season it lets through a driver who raced a third of the year; in a 7-race season of the 1950s it demands a perfect attendance record.

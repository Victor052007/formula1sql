# Did the grid really get much younger?

Queries:
[`queries/q5_grid_age.sql`](../queries/q5_grid_age.sql) (average age per season),
[`queries/q5_grid_age_change.sql`](../queries/q5_grid_age_change.sql) (change from one season to the next),
[`queries/q5_grid_turnover.sql`](../queries/q5_grid_turnover.sql) (which drivers left and arrived between two seasons),
[`queries/q5_1966_check.sql`](../queries/q5_1966_check.sql) (why 1966 broke the +1 rule)

With the sport growing so much in popularity, you might expect the average age of the grid to drop fast. But is that really the case?

## How I measured it

For every race entry, I calculated the driver's age on race day (race date minus date of birth), then averaged it per season. A driver who raced all season counts once for every race, so full-time drivers weigh more than one-race substitutes.

## 1950–1961: the big drop

The average age peaked in 1950 at 39.2 years and fell to 31.1 by 1961. That is eight years younger in just 11 seasons. Why?

- One cause might be the end of WW2. Racing stopped for about six years, so most drivers in the first championships had started their careers before the war.
- Another cause might be the Indianapolis 500 leaving the championship after 1960. It brought a completely different pool of American drivers who rarely raced in the rest of the season.

## 1961–1993: nothing changes

For three decades the average stayed between 29.7 and 32.4 years, with no clear trend.

## 1994–2019: the slow second drop

The average kept falling slowly until it hit an all-time low of 27.4 years in 2014, then stayed around 27.5 until 2019.

- The biggest single change came between 2012 and 2013. Eight drivers left the grid, including the two oldest, Schumacher and de la Rosa, and six arrived, five of them debutants. The average dropped by 1.77 years in a single season, the largest drop since 1954.
- The main reason for the slow decline was probably the rise of team driver academies, which bring drivers into F1 at a younger age, together with F1's growing popularity.
- Another reason is veterans retiring and making room for rookies.

## 2019–2024: the grid gets older again

F1 got more popular than ever, academies became more accessible, and sim racing became a new way into motorsport during the pandemic. So why didn't the grid keep getting younger?

The main reason is that the grid became stable. If nobody leaves or arrives, everyone ages by one year, and so does the average. From 2019 to 2023 the average rose by only 0.1 to 0.4 years per season, which means some rookies did arrive, but not enough to offset everyone else getting older. Some free seats also went to returning veterans instead of rookies, like Alonso in 2021 and Hülkenberg in 2023.

Between 2023 and 2024 the rotation stopped almost completely. All 20 drivers who started 2024 had already raced in 2023. The only driver who left was de Vries, who had been replaced early in 2023, and the three newcomers (Bearman, Colapinto and Doohan) only joined during 2024. The average rose by a full year, to 29.6, the oldest grid since 1995.

## Year-over-year change

To check the "+1 rule" on every season, I calculated how much the average changed from one season to the next, using `LAG()`.

The rule: if nobody leaves or arrives, everyone ages by one year, so the average rises by exactly one year. Aging alone can never push it above +1. Any rise bigger than that means the grid itself got older: young drivers left, or older drivers arrived.

- Only two seasons broke the rule: **1966 (+1.38)** and **1999 (+1.07)**. 2024, with +0.98, is the third biggest rise ever and the closest to the "pure" case of a grid that almost didn't change.
- **1999:** every driver who left after 1998 was younger than the grid average of 28.4. Tuero, the youngest driver on the grid, was only 20. The ones who arrived were not young rookies: Zanardi came back from CART at 32, Badoer returned after a break, and de la Rosa debuted at 28.
- **1966** has its own section below.
- The biggest drops were 1952 (−2.72), 2013 (−1.77), 1954 (−1.66) and 1994 (−1.30).

## 1966: the biggest rise ever

Why did the average age jump by 1.38 years in a single season? I ran several queries to find out.

- **Huge grid rotation:** 30 drivers left after 1965 and only 9 arrived. Why would so many drivers leave at once? 18 of their 50 entries came from a single race, the South African GP, which wasn't part of the championship anymore in 1966. Many of them didn't really leave F1, their only race was taken off the calendar.
- **But this doesn't explain the rise in age.** I first assumed the drivers who left were younger than the rest, but the data showed the opposite: they were slightly older, 31.34 against 30.89 for the ones who stayed. So their departure would have pulled the average down a bit, not up.
- **The real explanation is the drivers who arrived.** They averaged 33.74 years, compared to 32.11 for the ones who stayed. 1966 was also the year the engine rules changed, with engine capacity doubling from 1.5 to 3 litres. With such a big change, it makes sense that teams went for experienced drivers instead of rookies, like former world champion Phil Hill.

## Limitations

- The average is weighted by race entries, not by drivers, so full-time drivers count more than substitutes.
- An average hides individuals. Verstappen debuted at 17 in 2015, but one driver out of twenty barely moves the number.
- To compare grids I used `EXCEPT`, which only checks whether a driver raced at least once that season. A driver returning after a break, like Sutil in 2013, looks the same as a debutant.
- The +1 rule is only exact if every driver races the same number of races in both seasons. In 1966, even the drivers who stayed got 1.22 years older on average, because the older ones made up a bigger share of the race entries than the year before.

## Full results

<details>
<summary>Average age and change per season, 1950–2024</summary>

| Year | Avg. age | Change |
|---|---|---|
| 1950 | 39.19 | — |
| 1951 | 39.02 | −0.17 |
| 1952 | 36.30 | −2.72 |
| 1953 | 35.89 | −0.41 |
| 1954 | 34.23 | −1.66 |
| 1955 | 34.96 | +0.73 |
| 1956 | 34.22 | −0.74 |
| 1957 | 33.16 | −1.06 |
| 1958 | 32.51 | −0.65 |
| 1959 | 32.33 | −0.18 |
| 1960 | 32.04 | −0.29 |
| 1961 | 31.05 | −0.98 |
| 1962 | 30.82 | −0.23 |
| 1963 | 31.04 | +0.22 |
| 1964 | 31.38 | +0.34 |
| 1965 | 31.00 | −0.38 |
| 1966 | 32.38 | +1.38 |
| 1967 | 31.59 | −0.79 |
| 1968 | 31.40 | −0.19 |
| 1969 | 31.63 | +0.23 |
| 1970 | 30.98 | −0.65 |
| 1971 | 31.47 | +0.49 |
| 1972 | 31.00 | −0.47 |
| 1973 | 31.44 | +0.44 |
| 1974 | 30.90 | −0.53 |
| 1975 | 30.55 | −0.35 |
| 1976 | 30.75 | +0.20 |
| 1977 | 30.90 | +0.15 |
| 1978 | 31.15 | +0.25 |
| 1979 | 31.00 | −0.15 |
| 1980 | 30.42 | −0.58 |
| 1981 | 29.90 | −0.52 |
| 1982 | 29.66 | −0.24 |
| 1983 | 30.07 | +0.41 |
| 1984 | 30.12 | +0.05 |
| 1985 | 30.60 | +0.47 |
| 1986 | 31.39 | +0.79 |
| 1987 | 30.54 | −0.85 |
| 1988 | 30.43 | −0.11 |
| 1989 | 30.44 | +0.01 |
| 1990 | 30.50 | +0.06 |
| 1991 | 30.18 | −0.32 |
| 1992 | 30.11 | −0.07 |
| 1993 | 30.81 | +0.70 |
| 1994 | 29.51 | −1.30 |
| 1995 | 29.58 | +0.07 |
| 1996 | 29.30 | −0.28 |
| 1997 | 28.53 | −0.77 |
| 1998 | 28.41 | −0.13 |
| 1999 | 29.48 | +1.07 |
| 2000 | 28.86 | −0.62 |
| 2001 | 28.28 | −0.58 |
| 2002 | 28.94 | +0.66 |
| 2003 | 28.83 | −0.11 |
| 2004 | 27.87 | −0.96 |
| 2005 | 28.83 | +0.96 |
| 2006 | 28.95 | +0.12 |
| 2007 | 28.38 | −0.57 |
| 2008 | 28.19 | −0.19 |
| 2009 | 28.03 | −0.15 |
| 2010 | 28.50 | +0.47 |
| 2011 | 28.95 | +0.45 |
| 2012 | 29.28 | +0.32 |
| 2013 | 27.50 | −1.77 |
| 2014 | 27.38 | −0.13 |
| 2015 | 27.46 | +0.08 |
| 2016 | 27.51 | +0.06 |
| 2017 | 27.45 | −0.06 |
| 2018 | 27.56 | +0.11 |
| 2019 | 27.53 | −0.03 |
| 2020 | 27.66 | +0.13 |
| 2021 | 28.03 | +0.37 |
| 2022 | 28.23 | +0.19 |
| 2023 | 28.58 | +0.36 |
| 2024 | 29.56 | +0.98 |

</details>

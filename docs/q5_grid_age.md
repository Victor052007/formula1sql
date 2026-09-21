# Did the grid really get much younger?

Queries:
[`queries/q5_grid_age.sql`](../queries/q5_grid_age.sql) (average age per season),
[`queries/q5_grid_turnover.sql`](../queries/q5_grid_turnover.sql) (which drivers left and arrived between two seasons)

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

- The biggest single change came between 2012 and 2013. Eight drivers left the grid, including the two oldest, Schumacher and de la Rosa, and six arrived, five of them debutants. The average dropped by 1.8 years in a single season.
- The main reason for the slow decline was probably the rise of team driver academies, which bring drivers into F1 at a younger age, together with F1's growing popularity.
- Another reason is veterans retiring and making room for rookies.

## 2019–2024: the grid gets older again

F1 got more popular than ever, academies became more accessible, and sim racing became a new way into motorsport during the pandemic. So why didn't the grid keep getting younger?

The main reason is that the grid became stable. If nobody leaves or arrives, everyone ages by one year, and so does the average. From 2019 to 2023 the average rose by only 0.1 to 0.4 years per season, which means some rookies did arrive, but not enough to offset everyone else getting older. Some free seats also went to returning veterans instead of rookies, like Alonso in 2021 and Hülkenberg in 2023.

Between 2023 and 2024 the rotation stopped almost completely. All 20 drivers who started 2024 had already raced in 2023. The only driver who left was de Vries, who had been replaced early in 2023, and the three newcomers (Bearman, Colapinto and Doohan) only joined during 2024. The average rose by a full year, to 29.6, the oldest grid since 1995.

## Limitations

- The average is weighted by race entries, not by drivers, so full-time drivers count more than substitutes.
- An average hides individuals. Verstappen debuted at 17 in 2015, but one driver out of twenty barely moves the number.
- To compare grids I used `EXCEPT`, which only checks whether a driver raced at least once that season. A driver returning after a break, like Sutil in 2013, looks the same as a debutant.

## Full results

<details>
<summary>Average age per season, 1950–2024</summary>

| Year | Avg. age | Year | Avg. age | Year | Avg. age |
|---|---|---|---|---|---|
| 1950 | 39.2 | 1975 | 30.6 | 2000 | 28.9 |
| 1951 | 39.0 | 1976 | 30.7 | 2001 | 28.3 |
| 1952 | 36.3 | 1977 | 30.9 | 2002 | 28.9 |
| 1953 | 35.9 | 1978 | 31.2 | 2003 | 28.8 |
| 1954 | 34.2 | 1979 | 31.0 | 2004 | 27.9 |
| 1955 | 35.0 | 1980 | 30.4 | 2005 | 28.8 |
| 1956 | 34.2 | 1981 | 29.9 | 2006 | 28.9 |
| 1957 | 33.2 | 1982 | 29.7 | 2007 | 28.4 |
| 1958 | 32.5 | 1983 | 30.1 | 2008 | 28.2 |
| 1959 | 32.3 | 1984 | 30.1 | 2009 | 28.0 |
| 1960 | 32.0 | 1985 | 30.6 | 2010 | 28.5 |
| 1961 | 31.1 | 1986 | 31.4 | 2011 | 29.0 |
| 1962 | 30.8 | 1987 | 30.5 | 2012 | 29.3 |
| 1963 | 31.0 | 1988 | 30.4 | 2013 | 27.5 |
| 1964 | 31.4 | 1989 | 30.4 | 2014 | 27.4 |
| 1965 | 31.0 | 1990 | 30.5 | 2015 | 27.5 |
| 1966 | 32.4 | 1991 | 30.2 | 2016 | 27.5 |
| 1967 | 31.6 | 1992 | 30.1 | 2017 | 27.4 |
| 1968 | 31.4 | 1993 | 30.8 | 2018 | 27.6 |
| 1969 | 31.6 | 1994 | 29.5 | 2019 | 27.5 |
| 1970 | 31.0 | 1995 | 29.6 | 2020 | 27.7 |
| 1971 | 31.5 | 1996 | 29.3 | 2021 | 28.0 |
| 1972 | 31.0 | 1997 | 28.5 | 2022 | 28.2 |
| 1973 | 31.4 | 1998 | 28.4 | 2023 | 28.6 |
| 1974 | 30.9 | 1999 | 29.5 | 2024 | 29.6 |

</details>

# Analysis of the biomedical Covid-19 Literature
Authors: Alexander Schniedermann (DZHW Berlin), Arno Simons (TU Berlin)

This repo contains a data dashboard/virtual scientific publication. The research is a bibliometric analysis of <5 million biomedical research publications that were published during the Covid-19 pandemic. The dashboard is realised as shinylive application that is hosted on github: https://themetrifiedme.github.io/pandots/

# Version 1.5.2 (December 2024)
- This version features some additional calculations for Gini, HHI, skewness and kurtosis: [ac24_version_5.sql](./ac24_version_5.sql)
- Some texts have been updated
- some analytical dimensions from the previous versions have been removed
- This version is now independent from the code repo on gitlab which is, however, kept for the sake of version history. The repo with the previous versions can be found her: https://gitlab.com/aschniedermann/pandots

## Todo's and troubleshooting
- Add/remove features to the shinylive dashboard:
	- [ ] Change background color of pandemic vs. non-pandemic evidence base.
	- [ ] Add Conclusion Page
- [ ] Consider [Empirical CDF's](https://en.wikipedia.org/wiki/Empirical_distribution_function) as an alternative to (Hogg's) Kurtosis and Skewness. Empirical CDF's are not based on hypothetical distributions, but rather represent the real distribution of the data. 


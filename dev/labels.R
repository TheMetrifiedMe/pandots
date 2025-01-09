lblxaxisPanMon <- "Pandemic month (since January 2020)"
lblyaxisPortion <- "% of month"
lblyaxis2Portion <- "% of total"

lblProdExpl   = "<p><strong>Portions</strong></p><p>For each month, the mix of the document type groups results in 100%. Document types outside of our model are excluded from the analysis </p>"
lblRefResults = "<p><strong>Genre group</strong><br>Genre group of citing item</p><p>If article a cites article b, the former is the citing item and the latter the cited item. The cited items are the references of citing items</p>"
lblRefTbTResults = "<p><strong>Calculation Method</strong><br>Set-based: Referenced genres were summed across the set. Rates are calculated in the end.<br>Item-based: Rates of genres are calculated for each item and then averaged across the set.</p>"
lblRefHoggResults = "<p>For this perspective, all citing items are about Covid-19 and all their genres are combined</p>"

lblRefMethodHHI <- "<p><strong>HHI</strong><br>The absolute HHI is the common HHI which is the sum of the squared market shares of each publication. It neglects zero market shares and emphasizes the biggest shares. It takes values between 1/N (minimum) and 1 (monoply).</p>"
lblRefMethodGini <- "<p><strong>Gini Coefficient</strong><br>Focuses on dispersion rather than concentration by describing the area between the lorenz curve of a distribution and its potential perfect equality. It puts much more weight on the farer ends of the long-tailed data and is more insightful for citation data. It Takes values between 0 (perfect equality) and 1 (one paper received all citations).</p>"
lblRefMethodOTHER <- "<p><strong>Other Statistics</strong><br>Conventional kurtosis describes the mass of the distribution in the center and the tails in comparison to its shoulders but there is no uniform definition which makes interpretations of Kurtosis less robust for real world statements. Hogg's measures are percentile-based and size independent. However, skewness and kurtosis are not well-defined and less robust if 75% of the values are equal to the minimum which is often the case with citation distributions (i.e. dominance of papers with a single citation so that medium = minimum).</p>"


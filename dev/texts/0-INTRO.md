# Analysis of Pandemic Document Types (PanDots)
**Alexander Schniedermann¹, Arno Simons²**  
¹German Centre for Higher Education Research and Science Studies ([DZHW](https://www.dzhw.eu/) )  
²Technische Universität Berlin ([TU Berlin](https://www.tu.berlin/))  
*Contact: schniedermann@dzhw.eu* | [GitHub repo](https://github.com/TheMetrifiedMe/pandots)

**cite as:** Schniedermann, A., Simons, A. (2025). Analysis of Pandemic Document Types (PanDots). Zenodo. [https://doi.org/10.5281/zenodo.14626038](https://doi.org/10.5281/zenodo.14626038).



# Introduction

The urgency of the COVID-19 pandemic prompted a swift and robust response from the scientific community, especially in the medical fields. This lead to significant shifts in traditional publishing practices and a reconfiguration of the genre economy in science. For example, one of the most notable developments during this period was the unprecedented rise of preprints as a primary vehicle for disseminating COVID-19-related research ([Fraser et al. 2021](https://journals.plos.org/plosbiology/article?id=10.1371/journal.pbio.3000959)). Preprints, which are research papers shared publicly before undergoing formal peer review, became a critical resource for researchers, journalists, and policymakers alike. While they offered rapid and open access to the latest scientific findings, their lack of peer review meant that their conclusions had to be interpreted with caution, particularly by non-experts ([Simons and Schniedermann 2023](https://www.degruyter.com/document/doi/10.1515/9783110776546-003/html?lang=de)). While the pandemic rise of preprints has been covered in several bibliometric analyses, no studies so far have provided a holistic overview over the different document types in medical research during the Covid-19 outbreak. 

But studies from the history and sociology suggest that genre dynamics play an important role for the dynamics of scholarly communication. For example, scholars suggested how scientific results travel from papers to textbooks when becoming accpeted facts ([Fleck 1981 (1935)](https://press.uchicago.edu/ucp/books/book/chicago/G/bo25676016.html)). They showed how review articles employ a writing style that suggests scientific consensus and empirical wealth ([Myers 1991](https://wac.colostate.edu/books/landmarks/textual-dynamics/)). Further, genre systems and the interrelations of different represent and manifest the social intentions and thereby shape the expectations and actions of community members ([Bazerman 1994](https://www.taylorfrancis.com/chapters/mono/10.4324/9780203393277-14/systems-genres-enactment-social-intentions-aviva-freedman-peter-medway?context=ubx&refId=bfead445-1ade-44a3-98ab-63ec4ef75f5b)). In this regard, some genres are crucial in defining scholarly communication in biomediciene. Especially genres like systematic reviews are considered as the most reliable source of evidence that aggregates multiple, maybe conflicting, study results into a final take on any topic or research question ([Schniedermann et al. 2022](https://www.taylorfrancis.com/chapters/oa-edit/10.4324/9781003188612-8/top-hierarchy-guidelines-shape-systematic-reviewing-biomedicine-alexander-schniedermann-clemens-bl%C3%BCmel-arno-simons)). 

Against this background, we ask how the Covid-19 pandemic has impacted on the genre system and genre dynamics of the biomedical research sector. Which genres were produced at which stage of the pandemic? Which genres were cited and used as evidence-base for other pandemic research sutides? Have some genres played a more central role? These questions shall be adressed in an exploratory manner. This is done by conducting a comprehensive and exploratory bibliometric analysis of the evolving genre economy within the COVID-19 evidence base. We assume that the roles and interactions among these genre categories developed and shifted, reflecting the changing needs and priorities of the scientific community during the pandemic. 


# Data and methods

Our primary dataset consists of medical publications indexed in PubMed and OpenAlex, each assigned a PubMed identifier (PMID). In early 2024, we retrieved the complete metadata record from PubMed as of its December 2023 version. Since January 2020, marking the onset of the pandemic, this dataset has included 5.82 million unique items that are either Editorials, Letters, News, Case Reports, Randomized Controlled Trials Journal Aricles, Reviews, Cochrane Reviews, or Systematic Reviews. Because PubMed does not index preprint articles and only includes citation links to other PubMed items, we matched the dataset with the February 2024 snapshot of OpenAlex, provided by the German Competence Network Bibliometrics. During the matching there was a 5.7% loss of the original items while 280k preprints were added. The final dataset comprises of 5.76 million items.


**Preprints**

We identified preprints based on their registered source titles in OpenAlex. Unlike the rest of the dataset, only occasionally have a PMID, as they may not be indexed in PubMed. Additionally, preprints outside the medical domain are less comparable to the PubMed set. Therefore, we included in our sample only repositories with at least 15% of their preprints labeled as "Health Sciences" [topics](https://docs.openalex.org/api-entities/topics) in OpenAlex were included in the sample. Note that the full repositories were included, similar to the inclusion of PubMed as a whole. While different strategies were tested, the inclusion of whole repositories provided the best trade-off in favour of keeping most of what is relevant. Applying a topic-based filter on the item level, on the other hand, would have excluded many publications in medicine. For example, publications in radiology are often assigned the topic "physics" but including that topic, most of arXiv records would have been included as well. The covered preprint servers are:

- 'bioRxiv (Cold Spring Harbor Laboratory)'
- 'Research Square (Research Square)'
- 'Europe PMC (PubMed Central)',
- 'Authorea (Authorea)'
- 'medRxiv (Cold Spring Harbor Laboratory)',
- 'Authorea'
- 'HAL (Le Centre pour la Communication Scientifique Directe)'
- 'Zenodo (CERN European Organization for Nuclear Research)'
- 'PsyArXiv (OSF Preprints)'
- 'OSF Preprints (OSF Preprints)'


**Identification of COVID-19 Related Research**

We conducted the identification of COVID-19-related publications in two steps. First, we marked any publication assigned a COVID-19-related MeSH term as relevant to COVID-19 (see [NLM 2021](https://www.nlm.nih.gov/pubs/techbull/nd20/nd20_mesh_covid_terms.html)). However, due to the indexing time lag at NLM and the exclusion of preprints from their indexing, a second step was necessary. We then employed a title and abstract-based search system. Titles and abstracts were screened using the following full-text search query in PostgreSQL:

`to_tsquery('english','coronavirus | (corona <-> virus) | covid | (sars <-> cov <-> 2) | sars-cov-2 | sars-cov2 | (sarscov <-> 2) | sarscov-2 | sarscov2 | ncov2019 | (ncov <-> 2019) | ncov-2019 | 2019ncov | (2019 <-> ncov)')`

When comparing this approach to the MeSH term-based method, we found that the title and abstract screening achieved an overall precision of 0.9330, a recall of 0.9622, and an F1-Score of 0.9474. Therefore, our title and abstract-based screening proved to be a robust classification approach.


**Document Types**

Document type information was provided by PubMed. The PubMed data features a rich set of 79 different document types which are also multi-assigned. To reduce multi-assignment, we ranked each document type and reduced the classification to the highest ranks. Further, we separated the document types according to their intellectual function into four bigger groups, so that analysis and visualization is more accessible. All document types, their ranks and groupings can be found in [documenttypes.csv](./dev/ac24_documenttypes.csv). The four groups are:

1. *Problems:* (Editorials, letters, and news items) Problems are the scholarly content of journals that is not scientific content per se. We assume that editorials and news are used for the problematization of current trends and development, as well as agenda setting. 
2. *Preprints:* Any document type but without peer review. In this study, all items from the preprint servers listed above are considered as preprints. Preprints are the quickest way to communicate research findings and likely play a big role during the early pandemic.
3. *Articles:* (Jurnal articles, case reports, clinical trials) Full reportings of peer-reviews research results. Journal articles are the gold standard of scholarly communication.
4. *Syntheses:* (Systematic reviews, meta-analyses and narrative reviews) Comprehensive summaries of research on specific topics or questions. They represent the scientific consensus or final answer to particular research questions. Syntheses are considered the most reliable evidence base.

**Citation distributions**

To analyze the dynamics of citation distributions, we used Hogg's measures of skewness and kurtosis for non-normally distributed data ([Bono et al. 2019](https://www.mdpi.com/2073-8994/12/1/19)). Additionally, we calculated the Herfindahl-Hirschman Index (HHI) to assess the concentration of citations within the evidence base of COVID-19-related research. To facilitate comparisons across different months, we report the HHI as a proportion of the maximum possible HHI for each respective month. The maximum HHI represents a hypothetical scenario where a single article would receive all citations made during that month. Unlike other bibliometric analyses that calculate the HHI based on the concentration of citations to individual articles, we conceptualize all citations made in a given month as the "market" or evidence base for research published during that period. This approach follows the methodology outlined by [Lariviére et al. 2009](https://onlinelibrary.wiley.com/doi/abs/10.1002/asi.21011).

# Funding
This project was funded by the German Federal Ministry for Education and Research (01PU17017) and the
Competence Network Bibliometrics (01PQ17001).

## SQL code
```sql

--item volumes for the aggregate groups of items
create table ac24res_v5_production as
with reftableunique as (
	select citing_id, citing_type, citing_corona, citing_date, 
	max(allrefs) allrefs, 
	sum(case when cited_corona is true then typerefs else null end) coronarefs
	from ac24_referencebase_b
	where citing_type in (11,12,13,1,50,31,30,22,21,20) and cited_type in (11,12,13,1,50,31,30,22,21,20)	
	group by citing_id, citing_type, citing_corona, citing_date
), monthlyproduction as (
	select 
	citing_date, citing_corona,
	count(distinct citing_id) itemcount
	from reftableunique
	group by citing_date, citing_corona
), monthlyrates as (
	select citing_date, citing_corona, itemcount,
	(itemcount / nullif((sum(itemcount) over (partition by citing_corona)),0)::numeric) rate_by_coron,
	(itemcount / nullif((sum(itemcount) over ()),0)::numeric) rate_by_all
	from monthlyproduction
), typedstuf as (
	select aa.citing_date, aa.citing_corona,
			 case 
				 when citing_type in (11,12,13) then 'Problems'
				 when citing_type in (1) then 'Preprints'
				 when citing_type in (50,31,30) then 'Articles'
				 when citing_type in (22,21,20) then 'Syntheses'
			 	 else 'Other' 
		 	 end citing_type_agg,
	 	count(distinct citing_id) itemcount_type,
	 	max(bb.itemcount) monthlytotal,
	 	round(avg(allrefs),4) avg_refcount,
	 	round(avg(coalesce(coronarefs,0)/nullif(allrefs,0)),4) avg_refrate_corona,
		max(bb.rate_by_coron) rate_by_coron,
		max(bb.rate_by_all) rate_by_all
 	from reftableunique aa
 	left join monthlyrates bb on aa.citing_date = bb.citing_date and aa.citing_corona = bb.citing_corona
	group by aa.citing_date, aa.citing_corona, citing_type_agg
), results as (
	select *, 
	itemcount_type / nullif(monthlytotal,0)::numeric mon_type_rate
	from typedstuf
	order by citing_date, citing_corona
) select citing_date, citing_corona citingcorona, citing_type_agg citing_type, 
		round(avg_refcount,2) avg_refcount,
		round((avg_refrate_corona*100),2) avg_refrate_to_corona,
		itemcount_type itemcount, 
		monthlytotal,
		round((mon_type_rate*100),2) "percent",
		round((rate_by_coron*100),2) portion_by_corona,
		round((rate_by_all*100),2) portion_of_all
  from results

--Type by type reference counts for the aggregate groups of items
--citing_date, citingcorona, citing_type_agg, citedcorona, cited_type_agg, citationcount, percent,
  
create table ac24res_v5_cit_tbyt as 
with reftableunique as (
	select  citing_id,
			citing_date, 
			citing_corona, 
			case when citing_type in (11,12,13) then 'Problems'
				 when citing_type in (1) then 'Preprints'
				 when citing_type in (50,31,30) then 'Articles'
				 when citing_type in (22,21,20) then 'Syntheses'
			 	 else 'Other' 
		 	 end citing_type_agg,
		 	 cited_corona,
		 	 case when cited_type in (11,12,13) then 'Problems'
				 when cited_type in (1) then 'Preprints'
				 when cited_type in (50,31,30) then 'Articles'
				 when cited_type in (22,21,20) then 'Syntheses'
			 	 else 'Other' 
		 	 end cited_type_agg,
		 	 max(allrefs) allrefs,
		 	 sum(typerefs) typerefsgroup
	from ac24_referencebase_b
	where citing_type in (11,12,13,1,50,31,30,22,21,20) and cited_type in (11,12,13,1,50,31,30,22,21,20)
	group by citing_id, citing_date, citing_corona, citing_type_agg, cited_corona,cited_type_agg
), reftablegrouped as (
	select citing_date, citing_corona, citing_type_agg, cited_corona,cited_type_agg,
		 avg(typerefsgroup/nullif(allrefs,0)) 	over (partition by citing_date, citing_corona, citing_type_agg, cited_corona,cited_type_agg) percent_itm_based,
		 sum(allrefs) 							over (partition by citing_date, citing_corona, citing_type_agg, cited_corona,cited_type_agg) allrefs_grp,
		 sum(typerefsgroup) 					over (partition by citing_date, citing_corona, citing_type_agg, cited_corona,cited_type_agg) typerefs_grp,
		 sum(typerefsgroup) 					over (partition by citing_date, citing_corona, citing_type_agg, cited_corona) typerefs_all
	from reftableunique
), cleanup as 
(select distinct * from reftablegrouped
) select citing_date, citing_corona, citing_type_agg, allrefs_grp citing_refs_absolute, cited_corona,cited_type_agg, typerefs_grp cited_absolute,
	round((typerefs_grp/nullif(typerefs_all,0))*100,2) percent_setbased,
	round(percent_itm_based*100,2) percent_itembased
from cleanup




--distribution (Skewness and Kurtosis) and centralization (HHI) metrics for the citations set. The former offers conventional and Hogg's which sometimes receive NULL values
create table ac24res_v5_cit_hstats as
with uniqueitems as (
	select citing_id, citing_date, citing_corona,
			case when citing_type in (11,12,13) then 'Problems'
				 when citing_type in (1) then 'Preprints'
				 when citing_type in (50,31,30) then 'Articles'
				 when citing_type in (22,21,20) then 'Syntheses'
			 	 else 'Other' 
		 	 end cited_type_agg
	from ac24_referencebase_b
	where citing_type in (11,12,13,1,50,31,30,22,21,20)
	group by citing_id, citing_date, citing_corona, cited_type_agg
), citation_impact_table as (
	select aa.citing_date citing_date, 
		   aa.citing_corona citing_corona, 
		   cc.citing_id cited_items, 
		   cc.citing_corona cited_corona,
		   cc.cited_type_agg,
		   count(aa.citing_id) citationcount
	from uniqueitems aa
	inner join fiz_openalex_bdb_20240427.refs bb on aa.citing_id =bb.item_id_citing 
	inner join uniqueitems cc on bb.item_id_cited = cc.citing_id 
	group by aa.citing_date, aa.citing_corona, cc.citing_id, cc.cited_type_agg, cc.citing_corona
), pearsonstats as (
   select aa.citing_date, aa.citing_corona, aa.cited_corona, aa.cited_type_agg,
     min(citationcount) minimum,
     max(citationcount) maximum,
     avg(citationcount) mean,
	 mode() within group (order by citationcount) modus,
     sum(citationcount) total_cit_per_group,
     count(cited_items) total_itm_per_group,
     percentile_cont(0.50) within group (order by citationcount asc) as median,
     stddev_pop(citationcount) standarddev_population,
     var_pop(citationcount) variance_population,
     percentile_cont(0.05) within group (order by citationcount asc) as p05,
     percentile_cont(0.25) within group (order by citationcount asc) as p25,
     percentile_cont(0.75) within group (order by citationcount asc) as p75,
     percentile_cont(0.95) within group (order by citationcount asc) as p95
  from citation_impact_table aa
  group by aa.citing_date, aa.citing_corona, aa.cited_corona, aa.cited_type_agg
), hoggdata as (
	select 
	aa.citing_date, aa.citing_corona, aa.cited_corona, aa.cited_type_agg,
	avg(case when citationcount <= p05 		then citationcount else null end) mean_lower_5,
	avg(case when citationcount >= p95 		then citationcount else null end) mean_upper_5,
	avg(case when citationcount <= median 	then citationcount else null end) mean_lower_50,
	avg(case when citationcount >= median 	then citationcount else null end) mean_upper_50,
	avg(case when citationcount >= p25 and citationcount <= p75 then citationcount else null end) mean_middle_50,
	sum(((aa.citationcount/ nullif(bb.total_cit_per_group,0))::numeric) * ((aa.citationcount/ nullif(bb.total_cit_per_group,0))::numeric)) herfindahl_absolute,
    sum(POWER(aa.citationcount - bb.mean, 2)) sum_squared_deviation,
    sum(POWER(aa.citationcount - bb.mean, 3)) sum_cubed_deviation,
    sum(POWER(aa.citationcount - bb.mean, 4)) sum_fourth_deviation
	from citation_impact_table aa
	left join pearsonstats bb on aa.citing_date = bb.citing_date and aa.citing_corona = bb.citing_corona and aa.cited_corona=bb.cited_corona and aa.cited_type_agg = bb.cited_type_agg
	group by aa.citing_date, aa.citing_corona, aa.cited_corona, aa.cited_type_agg
), statresults as (
	select 
	aa.citing_date, aa.citing_corona, aa.cited_corona, aa.cited_type_agg, aa.total_cit_per_group total_cit_cnt, aa.total_itm_per_group total_itm_cnt,
	round((aa.total_itm_per_group / nullif(aa.total_cit_per_group,0))::numeric ,2) rate_of_distinct,
	round( (((mean - modus))	/	nullif(standarddev_population,0))::numeric ,2) pearson_first_skew,
	round( ((3 * (mean - median))	/	nullif(standarddev_population,0))::numeric ,2) pearson_third_skew,
	round( ((bb.mean_upper_5 - bb.mean_lower_5)	/	nullif((bb.mean_upper_50 - bb.mean_lower_50),0))::numeric ,2) hogg_kurtosis,
	round( ((bb.mean_upper_5 - bb.mean_middle_50)	/	nullif((bb.mean_middle_50 - bb.mean_lower_5),0))::numeric ,2) hogg_skewness,
	round(herfindahl_absolute, 2) herfindahl_absolute,
	round((((p75 - median) - (median - p25)) / nullif((p75 - p25),0)),2) bowley_galton_skew,
	round(((total_cit_per_group * sum_cubed_deviation) / nullif(((total_cit_per_group - 1) * (total_cit_per_group - 2) * POWER(SQRT(sum_squared_deviation / (total_cit_per_group - 1)), 3)),0)),2) conv_skewness,
	round(((total_cit_per_group * (total_cit_per_group + 1) * sum_fourth_deviation) / nullif(((total_cit_per_group - 1) * (total_cit_per_group - 2) * (total_cit_per_group - 3) * POWER(sum_squared_deviation / nullif((total_cit_per_group - 1),0), 2)),0) - (3 * POWER(total_cit_per_group - 1, 2) / nullif(((total_cit_per_group - 2) * (total_cit_per_group - 3)),0))),2) conv_kurtosis
	from pearsonstats aa
	left join hoggdata bb on aa.citing_date = bb.citing_date and aa.citing_corona = bb.citing_corona and aa.cited_corona=bb.cited_corona and aa.cited_type_agg = bb.cited_type_agg
) select * from statresults


--tests for Gini
create table ac24res_v5_cit_hstats_c as
with uniqueitems as (
	select citing_id, citing_date, citing_corona,
			case when citing_type in (11,12,13) then 'Problems'
				 when citing_type in (1) then 'Preprints'
				 when citing_type in (50,31,30) then 'Articles'
				 when citing_type in (22,21,20) then 'Syntheses'
			 	 else 'Other' 
		 	 end cited_type_agg
	from ac24_referencebase_b
	where citing_type in (11,12,13,1,50,31,30,22,21,20)
	group by citing_id, citing_date, citing_corona, cited_type_agg
), citation_impact_table as (
	select aa.citing_date citing_date, 
		   aa.citing_corona citing_corona, 
		   cc.citing_id cited_items, 
		   cc.citing_corona cited_corona,
		   cc.cited_type_agg,
		   count(aa.citing_id) citationcount
	from uniqueitems aa
	inner join fiz_openalex_bdb_20240427.refs bb on aa.citing_id =bb.item_id_citing 
	inner join uniqueitems cc on bb.item_id_cited = cc.citing_id 
	group by cc.citing_id, aa.citing_date, aa.citing_corona, cc.cited_type_agg, cc.citing_corona
), ordered_data AS (
    select
    	citing_date,
    	citing_corona,
    	cited_corona,
    	cited_type_agg,
        cited_items,
        citationcount,
        SUM(citationcount) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg ORDER BY citationcount, cited_items) AS cum_impact, -- Cumulative sum of income
        COUNT(*) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg) AS total_count, -- Total number of records
        SUM(citationcount) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg) AS total_impact, -- Total sum of income
	    stddev_pop(citationcount) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg) standarddev_population,
	    var_pop(citationcount) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg) variance_population,
	    avg(citationcount) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg) mean
    FROM citation_impact_table
), lorenz_curve AS (
    SELECT
    	citing_date,
    	citing_corona,
    	cited_corona,
    	cited_type_agg,
        cited_items,
        citationcount,
        cum_impact,
        total_count,
        total_impact,
        (ROW_NUMBER() OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg ORDER BY citationcount))::float / total_count AS population_fraction, -- Cumulative population fraction
        cum_impact / total_impact AS income_fraction, -- Cumulative income fraction
        (citationcount / nullif(total_impact,0))::numeric * (citationcount / nullif(total_impact,0))::numeric as herfindahl_single,
	    sum(POWER(citationcount - mean, 2)) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg) sum_squared_deviation,
	    sum(POWER(citationcount - mean, 3)) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg) sum_cubed_deviation,
	    sum(POWER(citationcount - mean, 4)) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg) sum_fourth_deviation
    FROM ordered_data
), lorenz_area_points AS (
    select
        citing_date,
    	citing_corona,
    	cited_corona,
    	cited_type_agg,
        cited_items,
        citationcount,
        cum_impact,
        total_count,
        total_impact,
        population_fraction,
        income_fraction,
        herfindahl_single,
        LAG(population_fraction, 1, 0) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg ORDER BY population_fraction) prev_population_fraction,
        LAG(income_fraction, 1, 0) OVER (partition by citing_date, citing_corona, cited_corona, cited_type_agg ORDER BY population_fraction) prev_income_fraction,
        sum(herfindahl_single) over (partition by citing_date, citing_corona, cited_corona, cited_type_agg) herfindahl_set,
		round(((total_impact * sum_cubed_deviation) / nullif(((total_impact - 1) * (total_impact - 2) * POWER(SQRT(sum_squared_deviation / (total_impact - 1)), 3)),0)),2) conv_skewness,
		round(((total_impact * (total_impact + 1) * sum_fourth_deviation) / nullif(((total_impact - 1) * (total_impact - 2) * (total_impact - 3) * POWER(sum_squared_deviation / nullif((total_impact - 1),0), 2)),0) - (3 * POWER(total_impact - 1, 2) / nullif(((total_impact - 2) * (total_impact - 3)),0))),2) conv_kurtosis
    FROM lorenz_curve
), lorenzareas as (
	select
		citing_date, citing_corona, cited_corona, cited_type_agg,
    	SUM((population_fraction - prev_population_fraction) * (income_fraction + prev_income_fraction) / 2) AS lorenz_area,
    	max(herfindahl_set) as HHI,
    	max(conv_skewness) as lognormal_skewness,
    	max(conv_kurtosis) as lognormal_kurtosis
	FROM lorenz_area_points
	group by citing_date, citing_corona, cited_corona, cited_type_agg
) select citing_date, citing_corona, cited_corona, cited_type_agg,  
	round((1-(2*lorenz_area))::numeric,4) as gini,
	round(HHI,4) as hhi,
	round(lognormal_skewness,2) as lognormal_skewness,
	round(lognormal_kurtosis,2) as lognormal_kurtosis
	from lorenzareas

```
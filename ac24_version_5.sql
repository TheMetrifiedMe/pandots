/* Analysis of the biomedical Covid-19 Literature - Version 5 (July 2024)

Further explanations and comments an be found in ./README.md

New analytical/output tables for the shiny board
- only data for bigger item groups
- one table with data for the production / output of Covid-19 related research
- one table with the citation metrics and indicators
*/



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

--combine both tables
select aa.*, bb.total_cit_cnt, bb.rate_of_distinct,
bb.hogg_kurtosis, bb.hogg_skewness, bb.pearson_coeff
from ac24res_v5_cit_hstats_c aa
left join ac24res_v5_cit_hstats bb on aa.citing_date = bb.citing_date and aa.citing_corona =bb.citing_corona and aa.cited_corona = bb.cited_corona and aa.cited_type_agg = bb.cited_type_agg 
where aa.citing_date <= 48



# St. Louis, MO Firearm Crime Web Map
The code for a web map I created using R's Shiny and Leaflet packages which analyzes which parts of St. Louis, MO have the most firearm-related crimes happening in 2017, and which police districts, schools and youth services centers there should be prioritized for distribution of further anti-gun violence resources as a result.

1.	Question to answer
Which parts of St. Louis, MO are most gun-related crimes happening in 2017? Which police districts, public middle schools, public high schools and youth services centers there should be prioritized for distribution of further anti-gun violence resources?

2.	Data Sources
•	St. Louis crimes (http://www.slmpd.org/Crimereports.shtml) (will no longer use SQL for this)
•	St. Louis police district boundaries shapefile (https://www.stlouis-mo.gov/data/boundaries/police-districts.cfm)   
•	St. Louis city boundary shapefile to clip best geocoded crime results (https://www.stlouis-mo.gov/data/boundaries/city-boundaries.cfm)
•	St. Louis youth services center locations, to be scraped from https://www.startherestl.org/youth-services.html
•	St. Louis pubic middle and high school locations, to be scraped from https://www.slps.org/domain/5110. 

3.	New technique that you will use to answer your question or present answer
Using R’s shiny and leaflet packages to make web maps showing the crime hotspots in relation to: police districts, public middle schools, public high schools and youth services centers containing information through popup text, and census tracts with demographic data accessible through popup text.

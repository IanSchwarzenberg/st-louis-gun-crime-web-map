# Final Project: Sheet 3 - Creation of User Interfact ("UI") Script for Web Map
# Ian Schwarzenberg
# CRIM 602 Fall 2018




#Load packages:
library(shiny)
library(leaflet)
library(sf)
library(dplyr)
#library(rsconnect)




#PART 1: CREATE WEB MAP'S UI
fluidPage(
  
  titlePanel("St. Louis, MO Police Districts and other Institutions that may need more Anti-Gun Violence Resources"),
  #titlePanel CREATES TITLE OF WEB MAP SITE
  p("by Ian Schwarzenberg, CRIM 602, Fall 2018"), #p() SETS JUST A TEXT BOX, IN THIS CASE IT IS USED AS A 
  #SUBTITLE FOR THE WEB MAP 
  
  tabsetPanel(type = "tabs", #MAKES IT SO EACH OUTPUTMAP FROM SERVER SCRIPT IS ITS OWN TAB
              tabPanel("Police Districts", leafletOutput("pd_map"), #SETS TITLE OF TAB AND WHICH OUTPUT MAP WILL
                       #BE DISPLAYED ON THAT TAB
                       p("Feel free to click on each police district to see its district number and percentage of 
                          firearm-related crimes happening within it in 2017."),
                       p("Data Sources:"),
                       p("Crimes: Downloaded from http://www.slmpd.org/Crimereports.shtml."),
                       p("City Boundary: Downloaded from https://www.stlouis-mo.gov/data/boundaries/city-boundaries.cfm."),
                       p("Police Districts: Downloaded from https://www.stlouis-mo.gov/data/boundaries/police-districts.cfm.")
              ), #ALL THESE p() COMMANDS CREATE TEXT TO BE DISPLAYED UNDERNEATH THE MAP ON THE TAB. REST OF CODE
              #FOLLOWS TEMPLATE OF LINES ABOVE TO CREATE REST OF TABS
              tabPanel("Public Middle Schools", leafletOutput("ms_map"),
                       p("Feel free to click on each middle school to see its name and percentage of  
                         firearm-related crimes happening within a quarter mile of it in 2017."),
                       p("Data Sources:"),
                       p("Crimes: Downloaded from http://www.slmpd.org/Crimereports.shtml."),
                       p("City Boundary: Downloaded from https://www.stlouis-mo.gov/data/boundaries/city-boundaries.cfm."),
                       p("Schools: Scraped from https://www.slps.org/domain/5110.")
              ),
              tabPanel("Public High Schools", leafletOutput("hs_map"),
                       p("Feel free to click on each high school to see its name and percentage of  
                         firearm-related crimes happening within a quarter mile of it in 2017."),
                       p("Data Sources:"),
                       p("Crimes: Downloaded from http://www.slmpd.org/Crimereports.shtml."),
                       p("City Boundary: Downloaded from https://www.stlouis-mo.gov/data/boundaries/city-boundaries.cfm."),
                       p("Schools: Scraped from https://www.slps.org/domain/5110.")
              ),
              tabPanel("Youth Services Centers", leafletOutput("ysc_map"),
                       p("Feel free to click on each youth services center to see its name and percentage of 
                          firearm-related crimes happening within a quarter mile of it in 2017."),
                       p("Data Sources:"),
                       p("Crimes: Downloaded from http://www.slmpd.org/Crimereports.shtml."),
                       p("City Boundary: Downloaded from https://www.stlouis-mo.gov/data/boundaries/city-boundaries.cfm."),
                       p("Youth Services Centers: Scraped from https://www.startherestl.org/youth-services.html.")
              )
  )
)

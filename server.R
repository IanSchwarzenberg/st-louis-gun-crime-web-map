# Final Project: Sheet 2 - Creation of Server Script for Web Map
# Ian Schwarzenberg
# CRIM 602 Fall 2018




#Load packages:
#install.packages("shiny")
library(shiny)
#install.packages("leaflet")
library(leaflet)
library(sf)
#install.packages("rsconnect")
#library(rsconnect) #RSCONNECT DEPLOYS THE APP TO A URL, BUT EVERY TIME IT TRIED TO DEPLOY IT KEPT CRASHING




#PART 1: LOAD IN DATA AND ADD LAT LON COLUMNS TO EACH POINT SHAPEFILE
#1A. Prepare the firearm-related crimes
crimes <- st_read("./www/StLouis_FirearmCrimes_SHP.shp") #NOTE HOW THE R PROJECT AUTOMATICALLY EXPECTS SHAPEFILES
#TO COME FROM THE WWW FOLDER, PREVENTING THE NEED TO SET A WORKING DIRECTORY
crimes$Lon <- gsub("c\\(|\\)", "", crimes$geometry) #CREATES A NEW LONGITUDE COLUMN BY EXCLUDING THE c, THE
#PARENTHESES (WHICH ARE PROTECTED BY \\), BUT THEN THE LAT COORDINATE IS ELIMINATED IN NEXT LINE TO GET FINAL
#NEW LONGITUDE COLUMN:
crimes$Lon <- gsub(",.*", "", crimes$Lon) #CREATES FINAL NEW LONGITUDE COLUMN
crimes$Lon <- as.numeric(crimes$Lon) #MAKES COLUMN NUMERIC SO THE MAP CAN READ IT
crimes$Lat <- gsub(".*,|\\)", "", crimes$geometry) #CREATES FINAL NEW LATITUDE COLUMN BY REMOVING EVERYTHING
#BEFORE THE LAT COORDINATE IN THE GEOMETRY COLUMN AS WELL AS THE CLOSED PARENTHESIS AT THE END OF THE LAT 
#COORDINATE IN THE GEOMETRY COLUMN AT THE SAME TIME USING | WHICH MEANS OR, AND THE CLOSED PARENTHESES IS
#PROTECTED BY \\
crimes$Lat <- as.numeric(crimes$Lat)


#1B. Prepare the city boundary
city_boundary <- st_read("./www/StLouis_CityBoundary_SHP.shp")
city_boundary <- st_transform(city_boundary, 4326) #I DO NOT NEED TO CREATE INDIVIDUAL LON AND LAT COLUMNS
#FOR POLYGONS, BUT DO NEED TO TRANSFORM THEM TO 4326 IF THEY ARE NOT IN THAT ALREADY


#1C. Prepare the police districts
PDs_All <- st_read("./www/Police_Districts_WITH_FACRIMEINFO_SHP.shp")
PDs_All <- st_transform(PDs_All, 4326)

PDs_FR <- st_read("./www/Police_Districts_FOR_FURTHER_RESOURCES_SHP.shp")
PDs_FR <- st_transform(PDs_FR, 4326)


#1D. Prepare the middle schools
MSs_All <- st_read("./www/Middle_Schools_WITH_FACRIMEINFO_SHP.shp")
MSs_All$Lon <- gsub("c\\(|\\)", "", MSs_All$geometry)
MSs_All$Lon <- gsub(",.*", "", MSs_All$Lon)
MSs_All$Lon <- as.numeric(MSs_All$Lon) 
MSs_All$Lat <- gsub(".*,|\\)", "", MSs_All$geometry)
MSs_All$Lat <- as.numeric(MSs_All$Lat) 

MSs_FR <- st_read("./www/Middle_Schools_FOR_FURTHER_RESOURCES_SHP.shp")
MSs_FR$Lon <- gsub("c\\(|\\)", "", MSs_FR$geometry)
MSs_FR$Lon <- gsub(",.*", "", MSs_FR$Lon)
MSs_FR$Lon <- as.numeric(MSs_FR$Lon) 
MSs_FR$Lat <- gsub(".*,|\\)", "", MSs_FR$geometry)
MSs_FR$Lat <- as.numeric(MSs_FR$Lat)


#1E. Prepare the high schools
HSs_All <- st_read("./www/High_Schools_WITH_FACRIMEINFO_SHP.shp")
HSs_All$Lon <- gsub("c\\(|\\)", "", HSs_All$geometry)
HSs_All$Lon <- gsub(",.*", "", HSs_All$Lon)
HSs_All$Lon <- as.numeric(HSs_All$Lon) 
HSs_All$Lat <- gsub(".*,|\\)", "", HSs_All$geometry)
HSs_All$Lat <- as.numeric(HSs_All$Lat)

HSs_FR <- st_read("./www/High_Schools_FOR_FURTHER_RESOURCES_SHP.shp")
HSs_FR$Lon <- gsub("c\\(|\\)", "", HSs_FR$geometry)
HSs_FR$Lon <- gsub(",.*", "", HSs_FR$Lon)
HSs_FR$Lon <- as.numeric(HSs_FR$Lon)
HSs_FR$Lat <- gsub(".*,|\\)", "", HSs_FR$geometry)
HSs_FR$Lat <- as.numeric(HSs_FR$Lat)


#1F. Prepare the youth services centers
YSCs_All <- st_read("./www/youth_centers_WITH_FACRIMEINFO_SHP.shp")
YSCs_All$Lon <- gsub("c\\(|\\)", "", YSCs_All$geometry)
YSCs_All$Lon <- gsub(",.*", "", YSCs_All$Lon)
YSCs_All$Lon <- as.numeric(YSCs_All$Lon)
YSCs_All$Lat <- gsub(".*,|\\)", "", YSCs_All$geometry)
YSCs_All$Lat <- as.numeric(YSCs_All$Lat)

YSCs_FR <- st_read("./www/Youth_Services_Centers_FOR_FURTHER_RESOURCES_SHP.shp")
YSCs_FR$Lon <- gsub("c\\(|\\)", "", YSCs_FR$geometry)
YSCs_FR$Lon <- gsub(",.*", "", YSCs_FR$Lon)
YSCs_FR$Lon <- as.numeric(YSCs_FR$Lon)
YSCs_FR$Lat <- gsub(".*,|\\)", "", YSCs_FR$geometry)
YSCs_FR$Lat <- as.numeric(YSCs_FR$Lat)




#PART 2: MAKE SERVER (THE SERVER FUNCTION SERVES AS THE SPOT FOR THE UI SCRIPT TO GET ITS CORRESPONDING MAPS)
shinyServer(function(input, output, session) {
  
  #2A. Create popups (FOUND OUT HOW TO DO IT HERE: https://rpubs.com/walkerke/leaflet_choropleth)
  
  PDs_FR_popup <- paste0("<strong>District: </strong>",
                          PDs_FR$DISTNO, #MAKES IT SO "District:" SHOWS UP NEXT TO EACH DISTRICT'S NUMBER.
                         #"<strong> AND </strong> ARE THE HTML TAGS WHICH LINE THEM UP
                          "<br><strong>% of Firearm-Related Crimes: </strong>", 
                         PDs_FR$FACrimPCT) #SAME PROCESS AS ABOVE, BUT FOR CRIME PERCENTAGE
  PDs_All_popup <- paste0("<strong>District: </strong>", 
                               PDs_All$DISTNO,
                          "<br><strong>% of Firearm-Related Crimes: </strong>", 
                          PDs_All$FACrimPCT)
  
  MSs_FR_popup <- paste0("<strong>School Name: </strong>", 
                               MSs_FR$HS_Name, #Refers to middle school names but forgot to change "HS_Name" to
                         #"MS_Name" in web map data creation code template when creating MSs_FR
                               "<br><strong>% of Firearm-Related Crimes: </strong>", 
                               MSs_FR$FACrimPCT)
  MSs_All_popup <- paste0("<strong>School Name: </strong>", 
                               MSs_All$HS_Name,
                               "<br><strong>% of Firearm-Related Crimes: </strong>", 
                               MSs_All$FACrimPCT)
  
  HSs_FR_popup <- paste0("<strong>School Name: </strong>", 
                         HSs_FR$HS_Name,
                         "<br><strong>% of Firearm-Related Crimes: </strong>", 
                         HSs_FR$FACrimPCT)
  HSs_All_popup <- paste0("<strong>School Name: </strong>", 
                          HSs_FR$HS_Name,
                          "<br><strong>% of Firearm-Related Crimes: </strong>", 
                          HSs_FR$FACrimPCT)
  
  YSCs_FR_popup <- paste0("<strong>Center Name: </strong>", 
                               YSCs_FR$Org_Name,
                               "<br><strong>% of Firearm-Related Crimes: </strong>", 
                               YSCs_FR$FACrimPCT)
  YSCs_All_popup <- paste0("<strong>Center Name: </strong>", 
                               YSCs_All$Org_Name,
                               "<br><strong>% of Firearm-Related Crimes: </strong>", 
                               YSCs_All$FACrimPCT)
  
  
  #2B. Create police district tab
  output$pd_map <- renderLeaflet({ #EACH "output" IS A MAP TAB, I STRUCTURE IT THAT WAY IN THE UI CODE
    
    leaflet() %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
      addPolygons( #addPolygons ADDS POLYGON SHAPEFILES TO MAP, FOUND OUT HOW TO DO FROM https://cran.r-project.org/web/packages/leaflet/leaflet.pdf
        data = city_boundary, #GETS DATA FROM PART 1 OF THIS CODE SHEET
        group="St. Louis City Boundary", #GIVES THE LAYER A NAME FOR THE LEGEND
        weight = 4, #SETS THICKNESS OF BOUNDARY LINE
        color = "darkorange", #SETS COLOR OF BOUNDARY LINE
        fillOpacity = 0) %>% #SETS OPACITY OF BOUNDARY POLYGON, IN THIS CASE IT IS 0 BECAUSE I JUST WANT THE 
      #OUTLINE
        #city boundary does NOT get a popup
      addPolygons(
        data = PDs_FR,
        group = "Police Districts Potential Distribution Candidates",
        weight = 1,
        fillColor="cyan",
        fillOpacity = 0.1,
        popup=PDs_FR_popup) %>% 
      addPolygons(
        data = PDs_All,
        group = "All Police Districts",
        weight = 1,
        fillColor="cyan",
        fillOpacity = 0.1,
        popup=PDs_All_popup) %>% 
      addCircles( #addCircles ADDS POINT SHAPEFILES TO MAP, FOUND OUT HOW TO DO FROM https://cran.r-project.org/web/packages/leaflet/leaflet.pdf
        data = crimes,
        lng = ~Lon, #SETS LONGITUDE TO LON COLUMN
        lat = ~Lat, #SETS LATITUDE TO LAT COLUMN
        group = "All Crimes Involving Firearms, 2017",
        weight = 1,
        color = "gray35",
        stroke = TRUE #MAKES IT SO POINT CIRCLES ARE GIVEN AN OUTLINE
      ) %>% 
      #crimes does NOT get a popup either
      addLayersControl(
        baseGroups = c("All Police Districts",
                       "Police Districts Potential Distribution Candidates",
                       "All Crimes Involving Firearms, 2017"), #addLayersControl CREATES LEGEND BOX WHERE USERS
        #CAN CLICK ON WHAT LAYER THEY WANT TO SEE ONE AT A TIME, THIS IS WHERE THE groups FROM ABOVE COME INTO
        #USE
        position = c("topright")) #PUTS LEGEND BOX IN TOP RIGHT OF SCREEN. REST OF SERVER CODE UP TO PART 3
    #FOLLOWS THE TEMPLATE ABOVE
  })
  
  
  
  #2C. Create middle school tab
  output$ms_map <- renderLeaflet({
    
    leaflet() %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
      addPolygons(
        data = city_boundary,
        group="St. Louis City Boundary",
        weight = 3,
        color = "darkorange",
        fillOpacity = 0) %>%
      addCircles(
        data = MSs_FR,
        lng = ~Lon, 
        lat = ~Lat,
        group="Public Middle Schools Potential Distribution Candidates",
        weight = 12.5,
        color="darkred",
        stroke = TRUE,
        popup=MSs_FR_popup) %>% 
      addCircles(
        data = MSs_All,
        lng = ~Lon, 
        lat = ~Lat,
        group="All Public Middle Schools",
        weight = 12.5,
        color="darkred",
        stroke = TRUE,
        popup=MSs_All_popup) %>% 
      addCircles(
        data = crimes,
        lng = ~Lon, 
        lat = ~Lat,
        group = "All Crimes Involving Firearms, 2017",
        weight = 0.25,
        color = "gray35",
        stroke = TRUE
      ) %>% 
      addLayersControl(
        baseGroups = c("All Public Middle Schools",
                       "Public Middle Schools Potential Distribution Candidates",
                       "All Crimes Involving Firearms, 2017"),
        position = c("topright"))
  })
  
  
  #2C. Create high schools tab
  output$hs_map <- renderLeaflet({
    
    leaflet() %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
      addPolygons(
        data = city_boundary,
        group="St. Louis City Boundary",
        weight = 3,
        color = "darkorange",
        fillOpacity = 0) %>%
      addCircles(
        data = HSs_FR,
        lng = ~Lon, 
        lat = ~Lat,
        group="Public High Schools Potential Distribution Candidates",
        weight = 12.5,
        color = "green",
        stroke = TRUE, 
        popup=HSs_FR_popup) %>% 
      addCircles(
        data = HSs_All,
        lng = ~Lon, 
        lat = ~Lat,
        group="All Public High Schools",
        weight = 12.5,
        color = "green",
        stroke = TRUE, 
        popup=HSs_All_popup) %>% 
      addCircles(
        data = crimes,
        lng = ~Lon, 
        lat = ~Lat,
        group = "All Crimes Involving Firearms, 2017",
        weight = 0.25,
        color = "gray35",
        stroke = TRUE
      ) %>% 
      addLayersControl(
        baseGroups = c("All Public High Schools",
                       "Public High Schools Potential Distribution Candidates",
                       "All Crimes Involving Firearms, 2017"),
        position = c("topright"))
  })
  
  
  #2D. Create youth services center tab
  output$ysc_map <- renderLeaflet({
    
    leaflet() %>%
      addProviderTiles(providers$CartoDB.PositronNoLabels) %>%
      addPolygons(
        data = city_boundary,
        group="St. Louis City Boundary",
        weight = 3,
        color = "darkorange",
        fillOpacity = 0) %>%
      addCircles(
        data = YSCs_FR,
        lng = ~Lon, 
        lat = ~Lat,
        group="Youth Services Centers Potential Distribution Candidates",
        weight = 12.5,
        color = "deeppink",
        stroke = TRUE, 
        popup=YSCs_FR_popup) %>% 
      addCircles(
        data = YSCs_All,
        lng = ~Lon, 
        lat = ~Lat,
        group="All Youth Services Centers",
        weight = 12.5,
        color = "deeppink",
        stroke = TRUE, 
        popup=YSCs_All_popup) %>% 
      addCircles(
        data = crimes,
        lng = ~Lon, 
        lat = ~Lat,
        group = "All Crimes Involving Firearms, 2017",
        weight = 0.25,
        color = "gray35",
        stroke = TRUE
      ) %>% 
      addLayersControl(
        baseGroups = c("All Youth Services Centers",
                       "Youth Services Centers Potential Distribution Candidates",
                       "All Crimes Involving Firearms, 2017"),
        position = c("topright"))
  })

  
    

#PART 3: DEPLOYED WEB MAP TO URL AT https://ischwarz.shinyapps.io/web_map/
  
})

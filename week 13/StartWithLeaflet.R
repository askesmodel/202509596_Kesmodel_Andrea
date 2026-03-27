###   GETTING STARTED WITH LEAFLET

# Try to work through down this script, observing what happens in the plotting pane. There are three
# initial example exercises, followed by a few questions and 5 tasks. 

# Review favorite backgrounds in:
# https://leaflet-extras.github.io/leaflet-providers/preview/
# beware that some need extra options specified

# To install Leaflet package, run this command at your R prompt:
install.packages("leaflet")
library(tidyverse)

# To be able to save your map, uncomment and install one of these packages. 
# If htmlwidget does not work, consider installing "htmltools" instead.
install.packages("htmlwidget") 
install.packages("htmltools")


# Activate the library
library(leaflet)
# uncomment and activate whichever one worked for you to install
# only needed for saving the map as .html
library(htmltools)

#library(htmlwidgets) 

########## Example 1: create a Leaflet map of Europe with addAwesomeMarkers() 

# Learn to create a map by plotting three point markers, called Robin, Jakub and Jannes.

# First, create labels for your points
popup = c("Robin", "Jakub", "Jannes")

# Next, you create a Leaflet map with these basic steps: 
# call the leaflet() function and pipe in some background maps ("tiles"), 
# and then addMarker() function with longitude and latitude.
# Run the pipeline below to see the result:
leaflet() %>%                                 # create a map widget by calling the leaflet library
  addProviderTiles("Esri.WorldPhysical") %>%  # add Esri World Physical map tiles explicitly
  addAwesomeMarkers(lng = c(-3, 23, 11),      # add point markers specified with longitude for 3 points
                    lat = c(52, 53, 49),      # and latitude for 3 points (coordinates fall in EU)
                    popup = popup)            # specify labels for points, which will appear if you click on the point in the map

########### Example 2: create a Leaflet map of Sydney with the setView() function 

# Note that there are no points or markers below, just background tiles. setView() function
# alone helps you focus and zoom the map in a particular area of the world.

# Now we are in Sydney
leaflet() %>%
  addTiles() %>%                              # add default OpenStreetMap map tiles
  addProviderTiles("Esri.WorldImagery",       # add custom Esri World Physical map tiles
                   options = providerTileOptions(opacity=0.5)) %>%     # make the Esri tile transparent
  setView(lng = 151.105006, lat = -33.8767231, zoom = 12)              # set the location of the map 
# Question 1: What is the order of longitude and latitude in the setView() function?

# Now let's go back to Europe again
# When the map defined below renders, click the box in top right corner
# in your map Viewer to select between different background layers

leaflet() %>% 
  addTiles() %>% 
  setView( lng = 2.34, lat = 48.85, zoom = 5 ) %>%  # let's use setView to navigate to our area
  addProviderTiles("Esri.WorldPhysical", group = "Physical") %>%  # add physical background
  addProviderTiles("Esri.WorldImagery", group = "Aerial") %>%  # add satellite image
  addProviderTiles("MtbMap", group = "Geo") %>%               # add geomorphic units map
  
  addLayersControl(                                 # we are adding layers control to the maps
    baseGroups = c("Geo","Aerial", "Physical"),
    options = layersControlOptions(collapsed = F))  # replace T with F and back and run it

# Question 2: How does the map above change if you replace the T 
# in the last line of code above with F?
#answer: If you replace the T with an F, you get a little box, where you can switch the map to show geo, Aerial or physical. A sort of menu, with options.



########### Example 3:  SYDNEY HARBOUR DISPLAY WITH 11 LAYERS

# Let's create a map with more background layers that allows
# interactive selection between multiple layers. This can be useful
# if you want to rendering historical maps illustrating change over time

# The chunk below sets the location and zoom level of your map
leaflet() %>% 
  setView(151.2339084, -33.85089, zoom = 13) %>%
  addTiles()  # checking I am in the right area


# Bring in a choice of Esri background layers  

# Create a basic base map
l_aus <- leaflet() %>%   # assign the base location to an object
  setView(151.2339084, -33.85089, zoom = 13)
l_aus

# Now, prepare to select backgrounds by grabbing their names
Esri <- grep("^Esri", providers, value = TRUE)
Esri

# Select backgrounds from among provider tiles. To view the options, 
# go to https://leaflet-extras.github.io/leaflet-providers/preview/
# Run the following three lines together!
for (provider in Esri){l_aus <- l_aus %>% 
  addProviderTiles(provider, group = provider)}
l_aus

# Map of Sydney, NSW, Australia
# We make a layered map out of the components above and write it to 
# an object called AUSmap
AUSmap <- l_aus %>%
  addLayersControl(baseGroups = names(Esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = Esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                        }") %>% 
  addControl("", position = "topright")

# run this to see your product
AUSmap

########## SAVE THE FINAL PRODUCT

# Save map as a html document (optional, replacement of pushing the export button)
# only works in root

# You will need an html library to save pretty maps:
# library(htmlwidgets)
saveWidget(AUSmap, "AUSmap.html", selfcontained = TRUE)

########################################  TASK NUMBER ONE


# Task 1: Create a Danish equivalent of AUSmap with Esri layers, 
# but call it DANmap. You will need it layer as a background for Danish data points.

l_dk <- leaflet() %>%   # assign the base location to an object
  setView( 10.85089,55.2339084, zoom = 13) %>% 
  addTiles()
l_dk

DANmap <- l_dk %>%
  addLayersControl(baseGroups = names(Esri),
                   options = layersControlOptions(collapsed = FALSE)) %>%
  addMiniMap(tiles = Esri[[1]], toggleDisplay = TRUE,
             position = "bottomright") %>%
  addMeasure(
    position = "bottomleft",
    primaryLengthUnit = "meters",
    primaryAreaUnit = "sqmeters",
    activeColor = "#3D535D",
    completedColor = "#7D4479") %>% 
  htmlwidgets::onRender("
                        function(el, x) {
                        var myMap = this;
                        myMap.on('baselayerchange',
                        function (e) {
                        myMap.minimap.changeLayer(L.tileLayer.provider(e.name));
                        })
                        }") %>% 
  addControl("", position = "topright")
DANmap
########################################
######################################## ADD DATA TO LEAFLET

# Before you can proceed to Task 2, you need to learn about coordinate creation. 
# In this section you will manually create machine-readable spatial
# data from GoogleMaps, load these into R, and display them in Leaflet with addMarkers(): 

### First, go to https://bit.ly/CreateCoordinates1
### Enter the coordinates of your favorite leisure places in Denmark 
# extracting them from the URL in googlemaps, adding name and type of monument.
# Remember to copy the coordinates as a string, as just two decimal numbers separated by comma. 

# Caveats: Do NOT edit the grey columns! They populate automatically!

### Second, read the sheet into R. You will need gmail login information. 
# IMPORTANT: watch the console, it may ask you to authenticate or put in the number 
# that corresponds to the account you wish to use.

# Libraries
install.packages("googlesheets4")
library(tidyverse)
library(googlesheets4)
library(leaflet)

# If you experience difficulty with your read_sheet() function (it is erroring out), 
# uncomment and run the following function:
gs4_deauth()  # run this line and then rerun the read_sheet() function below

# Read in the Google sheet you've edited
places <- read_sheet("https://docs.google.com/spreadsheets/d/1PlxsPElZML8LZKyXbqdAYeQCDIvDps2McZx1cTVWSzI/edit#gid=124710918",
                     col_types = "cccnncnc",   # check that you have the right number and type of columns
                     range = "DAM2026")  # select the correct worksheet name

glimpse(places)

places %>% 
  filter(!is.na(Longitude)) %>% 
  filter(!is.na(Latitude))

# Question 3: are the Latitude and Longitude columns present? YES
# Do they contain numeric decimal degrees? YES



# If your coordinates look good, see how you can use addMarkers() function to
# load them in a basic map. Run the lines below and check: are any points missing? Why?
studentmap<- leaflet() %>% 
  addTiles() %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = paste(places$Description, "<br>", places$Type))
saveWidget(studentmap, "studentmap.html", selfcontained = T)

DANmap %>% 
  addMarkers(lng = places$Longitude, 
             lat = places$Latitude,
             popup = paste(places$Description, "<br>", places$Type))
# Now that you have learned how to load points from a googlesheet to a basic leaflet map, 
# apply the know-how to YOUR DANmap object. 

########################################
######################################## TASK TWO


# Task 2: Read in the googlesheet data you and your colleagues created
# into your DANmap object (with multiple background layers you created in Task 1).

# Solution

######################################## TASK THREE

# Task 3: Can you cluster the points in Leaflet?
# Hint: Google "clustering options in Leaflet in R"

# Solution
studentmap <- leaflet %>% 
  addTiles %>% 
  addMarkers(lng=places$Longitude,
             lat=places$Latitude,
             popup=paste(places$Description,"<br>",places$Type),
             clusterOptions = markerClusterOptions()
             )

studentmap <- leaflet() %>%
  addTiles() %>%
  addMarkers(
    lng = places$Longitude,
    lat = places$Latitude,
    popup = paste(places$Description, "<br>", places$Type),
    clusterOptions = markerClusterOptions()   
  )

DANmap %>%
  addMarkers(
    lng = places$Longitude,
    lat = places$Latitude,
    popup = paste(places$Description, "<br>", places$Type),
    clusterOptions = markerClusterOptions()  
  )
######################################## TASK FOUR

# Task 4: Look at the two maps (with and without clustering) and consider what
# each is good for and what not.

# Your brief answer: Instead of having a lot of points scattered around, you can locate how many pin points are sorrounded in one area, which can also tell us a bit about where there are a lot of places to go, and contrariwise. It also means you have to zoom in on the place/pin point youd like to find, contreariwise to the map not using clustering, where you can more easily go through each pin point faster.  

######################################## TASK FIVE

# Task 5: Find out how to display the notes and classifications column in the map. 
# Hint: Check online help in sites such as 
# https://r-charts.com/spatial/interactive-maps-leaflet/#popup

# Solution
#Answer: This should already have been done in the previous code I ran, otherwise I must have misunderstood or not understood the question:)

######################################## CONGRATULATIONS - YOU ARE DONE :)
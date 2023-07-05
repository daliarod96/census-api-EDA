library(censusapi)
library(DBI)
library(RMySQL)


key <- 'YOUR KEY'
Sys.setenv(CENSUS_KEY = key)
readRenviron("~/.Renviron")
Sys.getenv("CENSUS_KEY")

#listCensusMetadata(name="2021/acs/acs5/", type = "geography")

# mine data about ethnicity, income, education, poverty, employment
ca_census = getCensus(name="2021/acs/acs5/",
                      vars = c("NAME", 
                               
                               #ethnicity / race
                               "B03002_006E",
                               "B03002_003E", 
                               "B03002_004E",
                               "B03002_005E", 
                               "B03002_007E",
                               "B03002_012E",
                               "B03002_008E", 
                               
                               # median household income in the past 12 months
                               "B19013D_001E",
                               "B19013H_001E", 
                               "B19013B_001E", 
                               "B19013C_001E", 
                               "B19013E_001E", 
                               "B19013I_001E",
                               "B19013F_001E",
                               
                               #under poverty line by race/ethnicity
                               "B17001D_002E", # asian
                               "B17001H_002E", # white
                               "B17001B_002E", # african american
                               "B17001C_002E", # indigenous american or alaska native
                               "B17001E_002E", # native hawaiian and pacific islander
                               "B17001I_002E", # hispanic latino
                               "B17001F_002E", # other race alone
                               
                               # educational attainment
                               # black
                               "C15002B_003E",
                               "C15002B_004E",
                               "C15002B_005E",
                               "C15002B_006E",
                               "C15002B_008E",
                               "C15002B_009E",
                               "C15002B_010E",
                               "C15002B_011E",
                               
                               # american indian or alaska native
                               "C15002C_003E",
                               "C15002C_004E",
                               "C15002C_005E",
                               "C15002C_006E",
                               "C15002C_008E",
                               "C15002C_009E",
                               "C15002C_010E",
                               "C15002C_011E",
                               
                               # asian
                               "C15002D_003E",
                               "C15002D_004E",
                               "C15002D_005E",
                               "C15002D_006E",
                               "C15002D_008E",
                               "C15002D_009E",
                               "C15002D_010E",
                               "C15002D_011E",
                               
                               #native hawaiian and other pacific islander
                               "C15002E_003E",
                               "C15002E_004E",
                               "C15002E_005E",
                               "C15002E_006E",
                               "C15002E_008E",
                               "C15002E_009E",
                               "C15002E_010E",
                               "C15002E_011E",
                               
                               # other
                               "C15002F_003E",
                               "C15002F_004E",
                               "C15002F_005E",
                               "C15002F_006E",
                               "C15002F_008E",
                               "C15002F_009E",
                               "C15002F_010E",
                               "C15002F_011E",
                               
                               # white
                               "C15002H_003E",
                               "C15002H_004E",
                               "C15002H_005E",
                               "C15002H_006E",
                               "C15002H_008E",
                               "C15002H_009E",
                               "C15002H_010E",
                               "C15002H_011E",
                               
                               # hispanic or latino
                               "C15002I_003E",
                               "C15002I_004E",
                               "C15002I_005E",
                               "C15002I_006E",
                               "C15002I_008E",
                               "C15002I_009E",
                               "C15002I_010E",
                               "C15002I_011E",
                               
                               
                               # employment status for population 16 years and over
                               "B23025_003E", # in civilian labor force
                               "B23025_005E", # in civilian labor force unemployed
                               
                               #poverty status total
                               "B17001D_001E", # asian
                               "B17001H_001E", # white
                               "B17001B_001E", # african american
                               "B17001C_001E", # indigenous american or alaska native
                               "B17001E_001E", # native hawaiian and pacific islander
                               "B17001I_001E", # hispanic latino
                               "B17001F_001E" # other race alone
                      ),
                      region = "county:*",
                      regionin = "state:06") 


# remove ,California from county names
ca_census$NAME <- str_sub(ca_census$NAME, 1, -13)
ca_census$NAME

# rename column NAME to name
colnames(ca_census)[3] <- 'name'

ca_census$less_than_hs <-0
ca_census$hs_ged <- 0
ca_census$college_or_associates <- 0
ca_census$bachelors_and_up <- 0

letters <- c('D', 'H', 'B', 'C', 'E', 'I', 'F')
ethnicity <- c('asian', 'white', 'black', 'indigenous', 'hawaiian', 'latino', 'other')
for (letter in letters){
  ca_census[[str_glue('less_than_hs_{ethnicity[which(letters==letter)]}')]]<- ca_census[[str_glue('C15002{letter}_003E')]]+ ca_census[[str_glue('C15002{letter}_008E')]]
  ca_census[[str_glue('hs_ged_{ethnicity[which(letters==letter)]}')]]<- ca_census[[str_glue('C15002{letter}_004E')]]+ ca_census[[str_glue('C15002{letter}_009E')]]
  ca_census[[str_glue('college_or_associates_{ethnicity[which(letters==letter)]}')]]<- ca_census[[str_glue('C15002{letter}_005E')]]+ ca_census[[str_glue('C15002{letter}_010E')]]
  ca_census[[str_glue('bachelors_and_up_{ethnicity[which(letters==letter)]}')]]<- ca_census[[str_glue('C15002{letter}_006E')]]+ ca_census[[str_glue('C15002{letter}_011E')]]
  
  ca_census$less_than_hs <- ca_census$less_than_hs + ca_census[[str_glue('less_than_hs_{ethnicity[which(letters==letter)]}')]]
  ca_census$hs_ged <- ca_census$hs_ged + ca_census[[str_glue('hs_ged_{ethnicity[which(letters==letter)]}')]]
  ca_census$college_or_associates <- ca_census$college_or_associates + ca_census[[str_glue('college_or_associates_{ethnicity[which(letters==letter)]}')]]
  ca_census$bachelors_and_up <-ca_census$bachelors_and_up + ca_census[[str_glue('bachelors_and_up_{ethnicity[which(letters==letter)]}')]]
  
  delete_cols <- c(str_glue('C15002{letter}_003E'), str_glue('C15002{letter}_008E'),str_glue('C15002{letter}_004E'),str_glue('C15002{letter}_009E'),str_glue('C15002{letter}_005E'), str_glue('C15002{letter}_010E'),str_glue('C15002{letter}_006E'),str_glue('C15002{letter}_011E'))
  ca_census<-ca_census[,!(names(ca_census) %in% delete_cols)]
}


# total population per county
ca_census$total <- ca_census$B03002_006E +
  ca_census$B03002_003E +
  ca_census$B03002_004E +
  ca_census$B03002_005E +
  ca_census$B03002_007E+
  ca_census$B03002_012E+
  ca_census$B03002_008E


for(i in 4:10){
  names(ca_census)[i] <- str_glue('total_{ethnicity[i-3]}')
}


# average income in the last 12 months per county
ca_census[ca_census$B19013D_001E == -666666666,]$B19013D_001E<-0
ca_census[ca_census$B19013H_001E == -666666666,]$B19013H_001E<-0
ca_census[ca_census$B19013B_001E == -666666666,]$B19013B_001E<-0
ca_census[ca_census$B19013C_001E == -666666666,]$B19013C_001E<-0
ca_census[ca_census$B19013E_001E == -666666666,]$B19013E_001E<-0
ca_census[ca_census$B19013I_001E == -666666666,]$B19013I_001E<-0
ca_census[ca_census$B19013F_001E == -666666666,]$B19013F_001E<-0
ca_census$income <-round(rowMeans(ca_census[,c('B19013D_001E','B19013H_001E','B19013B_001E','B19013C_001E', 'B19013E_001E','B19013I_001E', 'B19013I_001E')], na.rm=TRUE),0)


# rename income columns
for(i in 11:17){
  names(ca_census)[i] <- str_glue('income_{ethnicity[i-10]}')
}

# population below poverty line per county
ca_census$below_poverty <- rowSums(ca_census[,c("B17001D_002E","B17001H_002E","B17001B_002E","B17001C_002E", "B17001E_002E", "B17001I_002E","B17001F_002E")])
for(i in 18:24){
  names(ca_census)[i] <- str_glue('poverty_{ethnicity[i-17]}')
}


#delete_cols <- c("NAME_2","COUNTYNS", "GEOID", "AFFGEOID","NAMELSAD", "STUSPS", "STATE_NAME","LSAD","ALAND","AWATER")
#ca_census<-ca_census[,!(names(ca_census) %in% delete_cols)]

names(ca_census)

# rename labor force columns
names(ca_census)[25:26] <- c('total_labor_force', 'unemployed')

for(i in 27:33){
  names(ca_census)[i] <- str_glue('total_12_months_{ethnicity[i-26]}')
}


#Gather data US Census about Imperial 
imperial = getCensus(name="2021/acs/acs5/",
                     vars = c(
                       "NAME", 
                       
                       #ethnicity / race
                       "B03002_006E",
                       "B03002_003E", 
                       "B03002_004E",
                       "B03002_005E", 
                       "B03002_007E",
                       "B03002_012E",
                       "B03002_008E", 
                       
                       # median household income in the past 12 months
                       "B19013D_001E",
                       "B19013H_001E", 
                       "B19013B_001E", 
                       "B19013C_001E", 
                       "B19013E_001E", 
                       "B19013I_001E", 
                       "B19013F_001E", 
                       
                       #under poverty line by race/ethnicity
                       "B17001D_002E", # asian
                       "B17001H_002E", # white
                       "B17001B_002E", # african american
                       "B17001C_002E", # indigenous american or alaska native
                       "B17001E_002E", # native hawaiian and pacific islander
                       "B17001I_002E", # hispanic latino
                       "B17001F_002E", # other race alone
                       
                       #poverty status total
                       "B17001D_001E", # asian
                       "B17001H_001E", # white
                       "B17001B_001E", # african american
                       "B17001C_001E", # indigenous american or alaska native
                       "B17001E_001E", # native hawaiian and pacific islander
                       "B17001I_001E", # hispanic latino
                       "B17001F_001E" # other race alone
                     ),
                     region = "county subdivision:*",
                     regionin = "state:06+county:025") 

# keep just city name (remove county and state from string)
imperial$NAME <- str_sub(imperial$NAME, 1, -34 )

# rename column NAME to name
colnames(imperial)[4] <- 'name'

# total population per county
imperial$total <- imperial$B03002_006E + 
  imperial$B03002_003E +
  imperial$B03002_004E +
  imperial$B03002_005E +
  imperial$B03002_007E +
  imperial$B03002_012E +
  imperial$B03002_008E


# rename population columns
for(i in 5:11){
  names(imperial)[i] <- str_glue('total_{ethnicity[i-4]}')
}


# average income in the last 12 months per county
imperial[imperial$B19013D_001E == -666666666,]$B19013D_001E<-0
imperial[imperial$B19013H_001E == -666666666,]$B19013H_001E<-0
imperial[imperial$B19013B_001E == -666666666,]$B19013B_001E<-0
imperial[imperial$B19013C_001E == -666666666,]$B19013C_001E<-0
imperial[imperial$B19013E_001E == -666666666,]$B19013E_001E<-0
imperial[imperial$B19013I_001E == -666666666,]$B19013I_001E<-0
imperial[imperial$B19013F_001E == -666666666,]$B19013F_001E<-0
imperial$income <-round(rowMeans(imperial[,c('B19013D_001E','B19013H_001E','B19013B_001E','B19013C_001E', 'B19013E_001E','B19013I_001E', 'B19013I_001E')], na.rm=TRUE),0)


# rename income columns
for(i in 12:18){
  names(imperial)[i] <- str_glue('income_{ethnicity[i-11]}')
}


# population below poverty line per county
imperial$below_poverty <- rowSums(imperial[,c("B17001D_002E","B17001H_002E","B17001B_002E","B17001C_002E", "B17001E_002E", "B17001I_002E","B17001F_002E")])

# rename columns
for(i in 19:25){
  names(imperial)[i] <- str_glue('poverty_{ethnicity[i-18]}')
}

for(i in 26:32){
  names(imperial)[i] <- str_glue('total_12_months_{ethnicity[i-25]}')
}

names(imperial)

# connect to MySQL server
conn = dbConnect(MySQL(), dbname='CaliforniaDB', host='localhost', port=3306, user='root', password='')
dbListTables(conn)

# save dataframes into tables 
dbWriteTable(conn, 'ca_census', ca_census)
dbReadTable(conn, 'ca_census')

dbWriteTable(conn, 'imperial', imperial)
dbReadTable(conn, 'imperial')

# modify datatypes, set primary keys, and foreign keys to link the two tables together
dbSendQuery(conn, 'ALTER TABLE ca_census  MODIFY state INT(2);')
dbSendQuery(conn, 'ALTER TABLE imperial  MODIFY state INT(2);')
dbSendQuery(conn, 'ALTER TABLE ca_census  MODIFY county INT(3);')
dbSendQuery(conn, 'ALTER TABLE imperial  MODIFY county INT(3);')
dbSendQuery(conn, 'ALTER TABLE imperial  MODIFY county_subdivision INT(5);')
dbSendQuery(conn, 'ALTER TABLE ca_census ADD PRIMARY KEY (county)')
dbSendQuery(conn, 'ALTER TABLE imperial ADD PRIMARY KEY (county_subdivision)')
dbSendQuery(conn, 'ALTER TABLE imperial ADD FOREIGN KEY (county) REFERENCES ca_census(county);')

# disconnect from server
dbDisconnect(conn)

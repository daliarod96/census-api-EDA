library(tidyverse)
library(tigris)
library(ggrepel)
library(RColorBrewer)
library(DBI)
library(RMySQL)

# connect to MySQL server
conn = dbConnect(MySQL(), dbname='CaliforniaDB', host='localhost', port=3306, user='root', password='')
dbListTables(conn)

# open tables
ca_census <- dbReadTable(conn, 'ca_census')
imperial <- dbReadTable(conn, 'imperial')

# disconnect from server
dbDisconnect(conn)

# add spatial features 

# California geometry
ca_geom <- counties("CA", cb = TRUE, resolution = "20m")
ca_geom <- ca_geom[, (names(ca_geom) %in% c('NAMELSAD', 'geometry'))]
colnames(ca_geom)[1] <- 'name'

ca_census <- merge(ca_census, ca_geom, by=c("name"), all.x=TRUE)


#Imperial geometry
imperial_geom <- county_subdivisions(state = 'CA', county= 'Imperial')
imperial_geom <- imperial_geom[, (names(imperial_geom) %in% c('NAME', 'geometry'))]
colnames(imperial_geom)[1] <- 'name'

imperial <- merge(imperial, imperial_geom, by=c("name"), all.x=TRUE)


# population of Imperial map
imperial_population <- ggplot() +
  geom_sf(data = imperial, color="black", aes(fill = total, geometry = geometry), size=0.25) +
  geom_sf_label(data = imperial, aes(label=name, geometry=geometry))+
  scale_fill_distiller(palette = "Spectral",
                       limits=c(0,70000),
                       breaks = c(20000,40000,60000))+
  labs(title = 'Population of Imperial County, California', x='Latitude', y='Longitude') +
  guides(fill=guide_colorbar(title="Population (Total)"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'))

  imperial_population

# latino population throughout California, the US  
  
ethnicity = c('Asian', 'White', 'Black', 'Indigenous American or Alaska Native', 'Hawaiian Native or Pacific Islander', 'Hispanic or Latino', 'Other')
  
imperial_long <- imperial %>%
  gather(P, value,
         5:11)

levels = c('total_asian', 'total_white', 'total_black', 'total_indigenous', 'total_hawaiian', 'total_latino', 'total_other')
# race or ethnicity bar: Imperial County
ggplot(imperial_long, aes(x=name, y = value/total,fill=factor(P, levels=levels)))+
  scale_fill_brewer(palette = 'Spectral', labels=ethnicity)+
  geom_col(position=position_stack()) +
  coord_flip() +labs(title = 'Racial or Ethnic Distribution of Imperial County, California', y='Percentage', x='City') +
  guides(fill=guide_legend(title="Race or Ethnicity"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'),
        axis.text.y = element_text(face='bold'),
        axis.title.y = element_blank())



# map of california: latino community
# there is a concentration of latinos in the mid to southern area of California
ca_plot <- ggplot() +
  geom_sf(data = ca_census, color="black", aes(fill =(total_latino/total)*100, geometry=geometry), size=0.25) +
  scale_fill_distiller(palette = "Spectral") +
  labs(title = 'Concentration of Latinos in California', x='Latitude', y='Longitude') +
  guides(fill=guide_colorbar(title="Latino Population (%)"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold')) 
ca_plot
 
# Areas with Latinos tend to have more poverty 
# map of california: people in poverty
ca_plot <- ggplot() +
  geom_sf(data = ca_census, color="black", aes(fill =(below_poverty/total)*100, geometry=geometry), size=0.25) +
  scale_fill_distiller(palette = "Spectral") +
  labs(title = 'California Residents Below the Poverty Line', x='Latitude', y='Longitude') +
  guides(fill=guide_colorbar(title="Population in Poverty (%)"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold')) 
ca_plot


imperial_long <- imperial %>%
  gather(P, value,
         19:25
         )
# percentage of population in poverty by race
df <- data.frame( ethnicity = str_to_title(ethnicity),
                  pct_pov_ca = round(colSums(ca_census[,18:24])/colSums(ca_census[,27:33])*100,1),
                  pct_pov_imp = round(colSums(imperial[,19:25])/colSums(imperial[,26:32])*100,1)
)


pct_pov_ca <- round((sum(colSums(ca_census[,18:24]))/sum(colSums(ca_census[,27:33])))*100,1)

  
df_long <- df %>%
  gather(P, value, c(pct_pov_ca, pct_pov_imp))

ggplot(df_long, aes(x=ethnicity, y = value, fill=P))+
  scale_fill_manual(values = c( "#FDAE61","#ABDDA4"), labels = c('California','Imperial County'))+
  geom_col(position=position_dodge()) +
  geom_text(aes(label = value),
            position = position_dodge(width = .9),
            hjust = 0,
            fontface='bold',
            color="#5E4FA2")+
  geom_hline(aes(yintercept=pct_pov_ca, linetype = 'Statewide poverty level: 12.9%'), color='black')+
  scale_linetype_manual(name = "", values = c(2, 2), 
                        guide = guide_legend(override.aes = list(fill='#EBEBEB')))+
  labs(title = 'Percentage of population in poverty by race or ethnicity: \n California and Imperial County', y='Poverty (%)', x='') +
  guides(fill=guide_legend(title="Region"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'),
        axis.text.y = element_text(face='bold'))+
  coord_flip()


# median household income in the past 12 months
# it doesn't really tell us anything about disparity
ca_long <- ca_census %>%
  gather(P, value, 11:17)

ca_long$P

levels = c('income_asian', 'income_white', 'income_black', 'income_indigenous', 'income_hawaiian', 'income_latino', 'income_other')
ggplot(ca_long, aes(x=factor(P, levels=levels), y=value/1000, fill=factor(P, levels=levels))) + geom_boxplot() +
  scale_fill_brewer(palette="Spectral", labels=ethnicity) +
  labs(title = 'California median household income by race or ethnicity (2021)', x='' , y='Median income (in thousands)') +
  guides(fill=guide_legend(title="Race or ethnicity"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'), axis.text.x = element_blank()) +
  scale_x_discrete(labels=str_to_title(ethnicity))


key <- '7c7d85f4af444244e716b7307de6c5d620c5e868'
Sys.setenv(CENSUS_KEY = key)
readRenviron("~/.Renviron")
Sys.getenv("CENSUS_KEY")

# family income for the last 12 months: latinos 
latino_income = getCensus(name="2021/acs/acs5/",
                      vars = c("NAME","group(B19101I)"),
                      region = "county:*",
                      regionin = "state:06") 
latino_income <- latino_income %>% select(-contains('M'))
latino_income <- latino_income %>% select(-contains('A'))

# latino incomes for imperial
latino_income_imp <- vector(mode="numeric", length=6)
total <- sum(subset(latino_income, county =="025")[,3:18])
latino_income_imp[1]<- sum(subset(latino_income, county =="025")[,3:5])/total
latino_income_imp[2]<- sum(subset(latino_income, county =="025")[,6:9])/total
latino_income_imp[3] <- sum(subset(latino_income, county =="025")[,10:12])/total
latino_income_imp[4] <- subset(latino_income, county =="025")[,13]/total
latino_income_imp[5] <- subset(latino_income, county =="025")[,14]/total
latino_income_imp[6]<- sum(subset(latino_income, county =="025")[,15:18])/total
latino_income_imp <-round(latino_income_imp*100,1)



# latino incomes for california
latino_income_ca <- vector(mode="numeric", length=6)
total <- sum(colSums(latino_income[,3:18]))
latino_income_ca[1] <- sum(colSums(latino_income[,3:5]))/total
latino_income_ca[2] <- sum(colSums(latino_income[,6:9]))/total
latino_income_ca[3] <- sum(colSums(latino_income[,10:12]))/total
latino_income_ca[4] <- sum(latino_income[,13])/total
latino_income_ca[5] <- sum(latino_income[,14])/total
latino_income_ca[6] <- sum(colSums(latino_income[,15:18]))/total
latino_income_ca <-round(latino_income_ca*100,1)

# family income for the last 12 months: white people 
white_income = getCensus(name="2021/acs/acs5/",
                         vars = c("NAME","group(B19101H)"),
                         region = "county:*",
                         regionin = "state:06") 
white_income <- white_income %>% select(-contains('M'))
white_income <- white_income %>% select(-contains('A'))

# white incomes for imperial 
white_income_imp <- vector(mode="numeric", length=6)
total <- sum(subset(white_income, county =="025")[,3:18])
white_income_imp[1]<- sum(subset(white_income, county =="025")[,3:5])/total
white_income_imp[2]<- sum(subset(white_income, county =="025")[,6:9])/total
white_income_imp[3]<- sum(subset(white_income, county =="025")[,10:12])/total
white_income_imp[4]<- subset(white_income, county =="025")[,13]/total
white_income_imp[5] <- subset(white_income, county =="025")[,14]/total
white_income_imp[6] <- sum(subset(white_income, county =="025")[,15:18])/total
white_income_imp <-round(white_income_imp*100,1)

# white incomes for california
white_income_ca <- vector(mode="numeric", length=6)
total <- sum(colSums(white_income[,3:18]))
white_income_ca[1] <- sum(colSums(white_income[,3:5]))/total
white_income_ca[2] <- sum(colSums(white_income[,6:9]))/total
white_income_ca[3]<- sum(colSums(white_income[,10:12]))/total
white_income_ca[4]<- sum(white_income[,13])/total
white_income_ca[5]<- sum(white_income[,14])/total
white_income_ca[6] <- sum(colSums(white_income[,15:18]))/total
white_income_ca <-round(white_income_ca*100,1)

household_incomes <- data.frame(
  income = c('< 20', '20 < 40', '40 < 60', '60 < 75', '75 < 100', '>100'),
  latino_income_ca = latino_income_ca, 
  white_income_ca = white_income_ca, 
  latino_income_imp = latino_income_imp,
  white_income_imp = white_income_imp
)

order = c('latino_income_ca', 'white_income_ca', 'latino_income_imp', 'white_income_imp')

household_incomes_long <- household_incomes %>%
  gather(P, value, 2:5)

household_incomes_long

levels <- c('< 20', '20 < 40', '40 < 60', '60 < 75', '75 < 100', '>100') 
ggplot(data=household_incomes_long, aes(x=factor(P, order), y=value, fill=factor(income, levels=rev(levels)))) +
  geom_bar(stat='identity', position='stack') +
  scale_fill_brewer(palette='Spectral', breaks=household_incomes$income) +
  coord_flip() + theme(plot.title=element_text(size=14, face="bold")) +
  geom_text(aes(label = sprintf("%1.1f%%", value) ),
            position = position_stack(vjust=1),
            hjust = 1,
            fontface='bold',
            color="black")+
  scale_x_discrete(labels=c("latino_income_ca" = "CA: Latino", 'white_income_ca' ='CA: White', 'latino_income_imp' = "Imperial: Latino", 'white_income_imp' = 'Imperial: White'))+
  labs(title = '2021 Family income:\n White and Latino populations in CA and Imperial County', y='Population (%)', x='') +
  guides(fill=guide_legend(title="Income (thousands)"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'),
        axis.text.y = element_text(face='bold'))

#educational attaimnemt in california and imperial by race

levels = c('Less than high school', 'High school diploma or equivalent', 'Some college or associate\'s degree', 'Bacherlor\'s degree or higher')

edu_attainment <- data.frame(edu = levels,
                            Asian = round(colSums(ca_census[,38:41],na.rm=TRUE)/ sum(colSums(ca_census[,38:41]))*100,1),
                            White = round(colSums(ca_census[,42:45],na.rm=TRUE)/ sum(colSums(ca_census[,42:45]))*100,1),
                            Black = round(colSums(ca_census[,46:49],na.rm=TRUE)/ sum(colSums(ca_census[,46:49]))*100,1),
                            Indigenous = round(colSums(ca_census[,50:53],na.rm=TRUE)/ sum(colSums(ca_census[,50:53]))*100,1),
                            Hawaiian = round(colSums(ca_census[,54:57],na.rm=TRUE)/ sum(colSums(ca_census[,54:57]))*100,1),
                            Latino = round(colSums(ca_census[,58:61],na.rm=TRUE)/ sum(colSums(ca_census[,58:61]))*100,1),
                            Other = round(colSums(ca_census[,62:65],na.rm=TRUE)/ sum(colSums(ca_census[,62:65]))*100,1)
                          )


edu_attainment_long <- edu_attainment %>% gather(P, values, 2:8 )

education_plot <- ggplot(edu_attainment_long, aes(x=P, y=values, fill=factor(edu, levels=rev(levels)))) + 
  geom_bar(stat='identity', position='stack') + 
  geom_text(data = subset(edu_attainment_long, values >0), aes(x=P, y = values, label=sprintf("%1.1f%%",values)),
            position = position_stack(vjust=1),
            hjust = 1,
            fontface='bold',
            color="black")+
  labs(title = 'Educational attainment for the CA population of 25 years and over by race or ethnicity', y='%', x='') +
  guides(fill=guide_legend(title="Educational Attainment"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'),
        axis.text.y = element_text(face='bold'))+
  scale_fill_brewer(palette = 'Spectral', breaks = edu )+
  coord_flip()
education_plot

# educational attainment in Imperial County
edu_attainment_imp <- data.frame(edu = levels,
                             Asian = as.numeric(round(subset(ca_census, county =="25")[,38:41]/sum(subset(ca_census, county =="25")[,38:41])*100,1)),
                             White = as.numeric(round(subset(ca_census, county =="25")[,42:45]/sum(subset(ca_census, county =="25")[,42:45])*100,1)),
                             Black = as.numeric(round(subset(ca_census, county =="25")[,46:49]/sum(subset(ca_census, county =="25")[,46:49])*100,1)),
                             Indigenous = as.numeric(round(subset(ca_census, county =="25")[50:53]/sum(subset(ca_census, county =="25")[,50:53])*100,1)),
                             Hawaiian = as.numeric(round(subset(ca_census, county =="25")[,54:57]/sum(subset(ca_census, county =="25")[,54:57])*100,1)),
                             Latino = as.numeric(round(subset(ca_census, county =="25")[,58:61]/sum(subset(ca_census, county =="25")[,58:61])*100,1)),
                             Other = as.numeric(round(subset(ca_census, county =="25")[,62:65]/sum(subset(ca_census, county =="25")[,62:65])*100,1))
)

names(edu_attainment_imp)

edu_attainment_imp_long <- edu_attainment_imp %>% gather(P, values, 2:8 )

education_plot <- ggplot(edu_attainment_imp_long, aes(x=P, y=values, fill=factor(edu, levels=rev(levels)))) + 
  geom_bar(stat='identity', position='stack') + 
  geom_text(data = subset(edu_attainment_imp_long, values >0), aes(x=P, y = values, label=sprintf("%1.1f%%",values)),
            position = position_stack(vjust=1),
            hjust = 1,
            fontface='bold',
            color="black")+
  labs(title = 'Educational attainment for the Imperial County population of 25 years and over by race or ethnicity', y='%', x='') +
  guides(fill=guide_legend(title="Educational Attainment"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'),
        axis.text.y = element_text(face='bold'))+
  scale_fill_brewer(palette = 'Spectral', breaks = edu )+
  coord_flip()
education_plot


# link between educational attainment and poverty

ggplot(ca_census, aes(below_poverty/total, bachelors_and_up/total))+
  geom_point( color ="#66C2A5", size=3 ) +
  geom_smooth(method ="lm", color =  "#F46D43")+
  labs(title = 'Poverty levels by educational attainment in California:\n Bacherlor\'s degree or higher', y='Bachelor\'s and up (%)', x='Below poverty line (%)') +
  guides(fill=guide_legend(title="Educational Attainment"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'),
        axis.title.x = element_text(face='bold'),
        axis.title.y = element_text(face='bold'))


ggplot(ca_census, aes(below_poverty/total, college_or_associates/total))+
  geom_point( color ="#66C2A5", size=3 ) +
  geom_smooth(method ="lm", color =  "#F46D43")+
  labs(title = 'Poverty levels by educational attainment in California:\n Some college or associate\'s degree', y='Some college or associate\'s (%)', x='Below poverty line (%)') +
  guides(fill=guide_legend(title="Educational Attainment"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'),
        axis.title.x = element_text(face='bold'),
        axis.title.y = element_text(face='bold'))
ggplot(ca_census, aes(below_poverty/total, hs_ged/total))+
  geom_point( color ="#66C2A5", size=3 ) +
  geom_smooth(method ="lm", color =  "#F46D43")+
  labs(title = 'Poverty levels by educational attainment in California:\n High school diploma or equivalent', y='High school diploma or equivalent (%)', x='Below poverty line (%)') +
  guides(fill=guide_legend(title="Educational Attainment"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'),
        axis.title.x = element_text(face='bold'),
        axis.title.y = element_text(face='bold'))
  
ggplot(ca_census, aes(below_poverty/total, less_than_hs/total)) + 
  geom_point( color ="#66C2A5", size=3 ) +
  geom_smooth(method ="lm", color =  "#F46D43")+
  labs(title = 'Poverty levels by educational attainment in California:\n Less than high school diploma', y='Less than high school diploma (%)', x='Below poverty line (%)') +
  guides(fill=guide_legend(title="Educational Attainment"))+
  theme(plot.title = element_text(hjust = 0.5, face='bold'),
        axis.title.x = element_text(face='bold'),
        axis.title.y = element_text(face='bold'))


# things that should change in the census:
# intersection afrolatino 
# provide a category that makes it easier to get educational attainment by race (without gender)
# separate hispanic or latinx (not interchangeable)
# honestly just add more categories to race: what does "other" even mean?
# ethnicity and race are different
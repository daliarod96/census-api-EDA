# <p align="center">Exploratory Data Analysis of the Latino Population in Imperial County using the 2021 American Community Survey through the Census API on R</p>

# Introduction

I used R to analyze the Latino population of Imperial County, California through the 2021 American Community Survey. I compared Latinos in Imperial County with other racialized groups in the county and all of California. Specifically, I mined for information related to poverty, unemployment, and educational attainment for Latinos and other racialized or ethnic groups. I studied the relationship between these variables, and found that Latino communities like Imperial County tend to have higher rates of unemployment and poverty and lower rates of educational attainment than other groups in California. The analysis showed that educational attainment is associated with lower rates of unemployment and poverty, so I researched the state of higher education in Imperial County and offered solutions to issues that arose during my search.

# Exploratory Data Analysis

I grew up in Calexico, CA in the rural county of Imperial. Calexico is a small town with a population of about 40,000 thousand people. The closest we have to a metropolis in Imperial County is El Centro, a slightly larger town with a Panda Express, an In-N-Out, an IHOP, and a shopping mall. 

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/bf5acde6-e7d1-4f66-bd09-a83abba698f5" width="60%" height="60%" class="center"></p>

Imperial County is right next to the US-Mexico border so it has a very large Latino population. It actually has the largest concentration of Latinos out of any county in California.

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/501952f2-eecc-4e25-a516-093b9ca24735" width="60%" height="60%" class="center"></p>

California has a lot of Latinos overall, being the second largest ethnic group after White people. 

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/353c3f33-af6a-424b-816a-a565868dad66" width="60%" height="60%" class="center"></p>

Calexico, where I grew up, is made up of over 95% Latinos. As a child, I was very confused by my school textbooks that talked about the US as a diverse country and a "melting pot" of cultures. The place where I grew up in did not feel very diverse. I had only met a handful of people who were not Latino (especifically Mexican) before I moved to Los Angeles, CA to complete my undergraduate studies at UCLA. 

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/13c7eda1-f043-451d-bb97-7eca9949b16d" width="60%" height="60%" class="center"></p>

A large percentage of people in Imperial County is currently living in poverty. It is one of the poorest counties in all of California.

<p align="center"><img src="https://github.com/daliarod96/census-api-EDA/assets/79605544/4e08027a-4e1c-4edc-a22e-ca833d1d9dd3" width="60%" height="60%" class="center"></p>

Coincidentally (not), a linear model tells us that counties in California with large concentrations of Latinos are also associated with higher levels of poverty.

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/6e35b438-6b2f-4ecf-8ed5-cee296e7b24f" width="60%" height="60%" class="center"></p>

15.5% of Latinos in California are living under the poverty line in comparison to 8.7% of White people. In Imperial County, poverty rates are higher than those in California at large. 22.3% of Latinos in Imperial County are living in poverty in comparison to 10% of White people. Latinos, Indigenous people, Hawaiian Natives, Pacific Islanders, Black people, and an unspecified "Other" are the populations carrying the statewide poverty line over their shoulders. Poverty rates for Asian people in California are low. It must be noted this standalone fact does not reflect the entire scope of the Asian experience in the U.S.

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/ad7ffd96-27b8-4c96-8c5c-1593ff82a193" width="60%" height="60%" class="center"></p>

One possible reason for high poverty rates for Latinos in Imperial, and California as a whole, is a low income. Although the median household income does not tell us much about disparity, a closer look at family incomes for White people and Latinos in California reveal large differences between the two populations.

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/f0a6da8f-4871-4941-92c8-9be3297e2905" width="60%" height="60%" class="center"></p>


Almost twice as many White families in California make over $100,000 a year (59.2%) in comparison to Latino families (31.6%). Over half of White families in California are bringing in over $100,000. 53.2% of Latino families in California are bringing in less than $75,000 a year; that number is 63.6% in Imperial County. 16.5% of Latino families in Imperial County are surviving on less than $20,000 a year; 6.8% of White families are living under similar conditions. According to the [MIT Living Wage Calculator](https://livingwage.mit.edu/states/06), the required annual income before taxes for a single adult living in California is $44,175. The required annual income for a family of a single working adult and a child is $90,357. 

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/d24b773c-c8cd-465d-9201-315cc036ae33" width="60%" height="60%" class="center"></p>

The Imperial County also has the highest percentage of unemployed residents out of any county in California. 

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/2377eeb1-1da9-4421-a21b-79d4eb579682" width="60%" height="60%" class="center"></p>

California counties with higher concentrations of Latinos are also associated with higher concentrations of unemployment.

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/83148a18-cd70-4439-bd58-68ac95f9fb9a" width="60%" height="60%" class="center"></p>

California counties with higher concentrations of White people are associated with lower unemployment percentages.

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/088060fe-e516-4cee-8839-7a7394761426" width="60%" height="60%" class="center"></p>

In California, Latinos are the group with the highest concentration of residents without a high school diploma (33%) and the lowest concentration of residents with a Bachelor's degree or higher (14.9%) after the unspecified "Other." Only 4.7% of White people in all of California are not high school graduates and 45.4% have at least a Bachelor's degree. White people in California are 6x less likely to not hold a high school diploma and 3x more likely to have a university degree than Latinos. 


<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/e17019f3-f3a7-4e4a-8903-09d386f04c33" width="60%" height="60%" class="center"></p>

Less than 50% of Latinos in California and Imperial County have enrolled in any college education. 

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/4759229b-84ac-41ae-ae63-ffb39200ebae" width="60%" height="60%" class="center"></p>


Counties in California with high concentrations of residents without a high school diploma are associated with higher concentrations of poverty. Latinos have the second highest concentration of people without a high school diploma out of any race or ethnicity in California. 

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/bf5fb6b1-dafb-4bfc-8012-928ef64ee7a2" width="60%" height="60%" class="center"></p>

An associate's degree provides a near insubstantial relief from poverty. 28.8% of Latinos in Imperial County over the age of 25 are stuck in the limbo between a high school degree and a diploma from a 4-year university. 

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/64fd21a9-8f9f-41bb-9dd4-4d2b1eca3f4d" width="60%" height="60%" class="center"></p>

In California, Bachelor's degrees (or higher) are associated with lower poverty rates. 45.4% of White people in California have Bachelor's degrees in comparison to 14.9% of Latinos. White people in Imperial County have a 10% poverty rate, whereas 22.3% of Imperial County Latinos are living under the poverty line.

<p align="center"><img src="https://github.com/daliarod96/Census-api-EDA/assets/79605544/f3c797e7-fcfc-4f53-9eb1-6951e6e110c3" width="60%" height="60%" class="center"></p>

Bachelor's degrees (or higher) are also associated with lower unemployment rates. Imperial County has the highest percentage of unemployment in California. 

<p align="center"><img src="https://github.com/daliarod96/census-api-EDA/assets/79605544/9b1ba2f2-847b-4b01-a6ec-07f9514e1c71" width="60%" height="60%" class="center"></p>

# Discussion

Imperial County needs a lot of help. Low incomes, the highest unemployment rate out of any county in California, and low educational attainment are three factors leading to high poverty rates in Imperial County. The data shows that Imperial County is not an isolated case, but one of many predominantly Latino communities that face systemic oppression that keeps families from obtaining socioeconomic comfort. 

We saw that counties in California with more Bachelor's degrees are also associated with lower unemployment and poverty rates. On the opposite end, a high school diploma or less is associated with higher rates of poverty and unemployment. Associate's degrees provide minuscule relief from poverty. In Imperial County, only 13.3% of Latinos over the age of 25 have a Bachelor's degree or higher. 28.8% have some college or an associate's degree, 24.2% have at most a high school diploma or equivalent, and 33.6% are not high school graduates. Low rates of university degrees in Imperial County offer one explanation for its high poverty and unemployment rates.

The path towards lowering unemployment and poverty rates in Imperial County involves increasing access to diverse and affordable higher education. Although affordable, options for public higher education in the county are very limited. Imperial Valley College (IVC) is the only public 2-year college in Imperial County. The second nearest option is Palo Verde College which is 1.5 hours away. According to the [U.S. Department of Education College Scorecard](https://collegescorecard.ed.gov/school/?115861-Imperial-Valley-College), IVC's average annual cost is $1,234, which is significantly lower than the average in the country ($8,528). It has an enrollment of 6,385 students, where 92% are Hispanic or Latino. 48% of students are full-time, which is 24% above the average (almost double) for all of California [California Community Colleges](https://collegescorecard.ed.gov/school/?115861-Imperial-Valley-College). According to the [IVC Fact Book](https://www.imperial.edu/docs/research-planning/fact-books/10889-2020-ivc-fact-book/file), the top educational goals of Fall 2019 were: to obtain an Associate's degree and transfer to a 4-year university (49.6%), to obtain an Associate's degree without transferring (12.0%), to transfer to a 4-year university without an Associate's degree (7.1%) and 4-year college prerequisites (4.2%). 40% of students graduate within 8 years, 8% above the average for 2-year schools in the US (32%), and 18% transferred. 39% withdrew and 2% are still enrolled, meaning that some students' educational needs are not being met at IVC. Withdrawal rates could be in part attributed to IVC's high student-faculty ratio which is 32:1, more than double the national average of 14:1 [(source)](https://www.usnews.com/education/best-colleges/the-short-list-college/articles/16-colleges-with-the-lowest-student-faculty-ratios). The student-faculty ratio indicates that there is a high demand for higher education in Imperial County. Such demand can be satisfied by increasing the number of faculty and offering more classes.  

San Diego State University's (SDSU) campus in Imperial County is the only public university in Imperial County. However, it is not a 4-year university unless you major in criminal justice or psychology, where you have the option to enroll as a first-time freshman. According to its [website](https://catalog.sdsu.edu/content.php?catoid=5&navoid=396), SDSU-Imperial offers the last two years of undergraduate education for students who wish to major in Criminal Justice, English, History, Latin American Studies, Liberal Studies, Mathematics, Nursing, Psyhcology, Public Administration, Social Science, Spanish and Public Health (last one is starting Fall 2024). For the [same tuition fee](https://student-accounts.sdsu.edu/tuition) ($2871 for full-time undergraduates as of Fall 2023), students at SDSU's campus in San Diego can pick from hundreds of majors in 97 areas. Students in Imperial County who want to study economics, engineering, science, art, music, achitecture, or a non-Latin American culture must travel out of state or at least two hours within California to complete their education. For these students, cost of living becomes another factor. When I went to UCLA I had to take out student loans because my awarded grants did not cover cost of living, scholarships were very competitive, and my parents could not afford to support me. In a county where over 65.6% of families have an income below $75,000 dollars, yet the statewide required annual income is at least $90,000 for families with a single child [(source)](https://livingwage.mit.edu/states/06), I imagine a lot of aspiring university students at Imperial County are caught in a similar situation, and many might not want to risk accruing debt. The government could issue need-based cost of living grants for students who wish to enroll in university. Universities usually provide cost of living estimates, so grant amounts could be based off of them. More Imperial Valley students would have the option to transfer to 4-year universities without the risk of student debt. Another option is that SDSU could expand its campus in Imperial County. This expansion could involve adding more majors and more options for students to enroll as first time freshmen. From construction, to faculty, and administration, this would create a lot of jobs. For five years, SDSU Imperial Valley campus transfer students have kept [higher full-time 2 year graduation rates](https://asir.sdsu.edu/graduation-progress-data/new-transfer-graduation-rates/) than transfers students at its San Diego campus (70.1% vs. 60.3% in 2019). It is worth investing in a population that clearly takes advantage of the education at their disposal. 


# Conclusion
Imperial County is one of many predominantly Latino communities in California that face significant barriers for obtaining socioeconomic comfort. In California, lower poverty and unemployment rates are associated with higher rates of Bachelor's (or higher) degrees, yet only 13.3% of Latinos in Imperial County have received a university diploma. Students in Imperial County are clearly taking advantage of their education, with local schools, IVC and SDSU, having above average graduation rates. However, higher education in Imperial County is limited, and many Latino students might not have the option to pursue university outside of the county due to low family income. Investing in higher education through need-based cost of living grants for university students or through the expansion of existing institutions of higher education (SDSU and IVC) may lead to more Bachelor's degrees being awarded in Imperial County, thus lower poverty and unemployment rates. The proposed solutions are grand but in scale with the problem at hand.

# Sidenote

While completing this project, I could not help but notice that the Census needs to update its categories pertaining to race and ethnicity. 

The Census does not have an isolated cateogry for Latinos. The category is called "Hispanic or Latino." Hispanic and Latino are not interchangeable terms. Hispanic refers to anybody who speaks Spanish. This includes people from Spain, who are European and mostly White.  Spanish people are not Latinos. Our cultures differ in everything but the language that we speak. We should not pigeonholed into the same category. Furthermore, interchangeability of Hispanic and Latino is based on the stereotype that all Latinos speak Spanish. Brazilians speak Portuguese and there are over 600 different languages spoken all over Latin America. 

Afrolatinos need to be accounted for in the Census. The Census separates White (Latino) and White (Not Latino) people to account for the intersection of these two identities. However, it provides no separation between Black (Latino) and Black (Not Latino) people. Afrolatinos face various prejudices in the Census and not providing them with their own category is one of them.









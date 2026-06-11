#RStudios Script: Yodhvir Hyare, Ritu Sidhu, Sharif Lodin, and Ayush Jain
# Load datasets
managers <- read.csv("managers.csv")
managers_append <- read.csv("managers_append.csv")
manager_bonus_1 <- read.csv("manager_bonus-1.csv")
#1 - Data Preparation

#a. - The dataset is missing information from 10 managers. Append the data in “managers_append.csv” into the main dataset “managers.csv".
managers_new_appended <- rbind(managers,managers_append)
print(managers_new_appended)

#b. - Information about manager bonuses was found for most employees. Merge the file “manager_bonus.csv” into the appended dataset. Keep all the employees from the main dataset.
managers_new_merged <- merge(managers_new_appended,
                             manager_bonus_1,
                             by="employee_id",
                             all.x=TRUE)
print(managers_new_merged)

#2 - Summarize Key Manager Characteristics

#a. - Compute the descriptive statistics of two numerical variables (mean, median, minimum, maximum) and two categorical variables (proportion).

#Numerical Variables (1)
mean(managers_new_merged$yrs_employed)
median(managers_new_merged$yrs_employed)
min(managers_new_merged$yrs_employed)
max(managers_new_merged$yrs_employed)

#Numerical Variables (2)
mean(managers_new_merged$test_score)
median(managers_new_merged$test_score)
min(managers_new_merged$test_score)
max(managers_new_merged$test_score)

#Categorical Variables (Proportion) (1)
proportion_1 <- table(managers_new_merged$performance_group)
prop_1 <- proportion_1/sum(proportion_1)
print(prop_1)

#Categorical Variables (Proportion) (2)
proportion_2 <- table(managers_new_merged$city)
prop_2 <- proportion_2/sum(proportion_2)
print(prop_2)

#b. - What do these summaries suggest about the managers? Interpretation must tie to HR action (hiring, training, staffing).

#Numerical Variables (1) - These summaries suggest that most managers have at least 4 years or more of managing experience (according to the median value).

#Numerical Variables (2) - These summaries suggest that most managers scored an average score of 242 (according to the median value).

#Categorical Variables (Proportion) (1) - These summaries suggest that 23% of the managers were placed at the bottom of the performance group, 64% were placed in the middle, and 13% were placed at the top.

#Categorical Variables (Proportion) (2) - These summaries suggest that 11% of the managers are located in Chicago, 4% are located in Houston, 1% are located in Miami, 34% are located in New York, 5% are located in Orlando, 10% are located in San Francisco, and 35% are located in Toronto.

#3 - High Demand: Create a variable “CPE” (customers per employee) that calculates the number of customers per group size.

CPE <- managers_new_merged$customers/managers_new_merged$group_size
#Add CPE as a column to the dataset
managers_new_merged$CPE <- managers_new_merged$customers / managers_new_merged$group_size
print(CPE)

#a. How is the number of customers by employee distributed? Are there outliers?
summary(CPE)
hist(CPE,
     main = "Distribution of Customers per Employee (CPE)",
     xlab = "Customers per Employee",
     col = "green")
boxplot(CPE,
        main = "Distribution of Customers per Employee (CPE)",
        xlab = "Customers per Employee",
        col = "lightblue")
#Yes, there are outliers.
boxplot.stats(CPE) 
#There are 14 outliers in total.

#b. How many managers have high demand, i.e., more than 3 customers per Employee?
sum(CPE>3)
#19 managers have high demand (more than 3 customers per employee).

#c. Extract a dataset containing the employee id, city, performance group, and CPE for the managers with high demand, ordered by the highest CPE. Save it as csv.

#Extracting the dataset
managers_high_demand <- subset(managers_new_merged, CPE > 3)
print(managers_high_demand)

#Selecting the required columns
high_demand <- managers_high_demand[,c("employee_id","city","performance_group","CPE")]
print(high_demand)

#Ordering the CPE by the highest
high_demand_highest <- high_demand[order(-high_demand$CPE),]
print(high_demand_highest)

#Saving it as a csv
write.csv(high_demand_highest,"high_demand_managers.csv")

#Checking saved csv
getwd()
list.files()

#4 Relationship Examination - Examine the relationship between managers’ performance group and their efficiency, measured as customers per employee.

#a. - Use the appropriate plot to compare the distribution of CPE across performance groups.
boxplot(CPE ~ performance_group, 
        data = managers_new_merged,
        main = "CPE Distribution by Performance Group",
        xlab = "Performance Group",
        ylab = "Customers per Employee (CPE)",
        col = c("coral", "blue", "green"))

#b. - Compute the average CPE for each performance group.
avg_cpe <- aggregate(CPE ~ performance_group, 
                     data = managers_new_merged, 
                     FUN = mean)
print("Average CPE by Performance Group:")
print(avg_cpe)

#c. - Do higher-performing managers tend to serve more customers per employee?
# When it comes to CPE, the higher performance group managers do not serve more, and instead, it is the complete opposite. The bottom group serves the most (1.92 CPE), followed by the middle (1.85 CPE), and finally the top (1.74 CPE).

#5 - Information about manager bonuses was found for most employees, but not all.

#a. - How many employees are missing bonus score information?
missing_bonuses <- sum(is.na(managers_new_merged$bonus_score)) 
print(paste("Number of employees missing bonus score:", missing_bonuses))
# 54 employees are missing their bonuses.

#b. - What is the average bonus score?
avg_bonus <- mean(managers_new_merged$bonus_score, na.rm = TRUE)
print(paste("Average bonus score:",avg_bonus))
# The average bonus score is 73.80

#c. - Replace all missing bonus score values with this average
managers_new_merged$bonus_score[is.na(managers_new_merged$bonus_score)] <- avg_bonus
print(avg_bonus)
# 54 missing values records were replaced with the mean score of 73.80

#6 - Contingency table

#a. - Create a contingency table showing the relationship between performance group and whether the manager worked long hours in the past week.
perform_high_hours <- xtabs(~ performance_group + high_hours_flag,
                            data = managers_new_merged)
print(perform_high_hours)

#b. - Based on this data, do higher-performing managers tend to work longer hours, or is high-hour workload independent of performance? Find if there is a significant association between these two variables.

#Based on this data, 55% of top performers worked long hours last week, 39% of middle performers worked long hours last week, and 30% of bottom performers worked long hours last week. Therefore, based on the data, higher-performing managers do tend to work longer hours.
perform_hours_assoc <- chisq.test(perform_high_hours)
print(perform_hours_assoc)
#Based on this data and test, high-hour workload is not independent of performance. This is because the p-value is 0.0006497. Since the p-value is less than 0.05, we have to reject the null hypothesis: high-hour workload is independent of performance. Thus, indicating that a high-hour workload is not independent of performance. In fact, high-performing managers are actually more likely to work long hours compared to middle and bottom-performing managers.

#7 - Categorical Plots: City

#a. - Create a bar plot showing the frequency of managers by city, ordered in decreasing order.

#Changing San Francisco to SF so the plot is readable.
managers_new_merged$city[managers_new_merged$city == "San Francisco"] <- "SF"
print(managers_new_merged$city)

#Create a frequency table for managers and the city.
manager_city_freq <- table(managers_new_merged$city)
print(manager_city_freq)

#Sort the frequency table in decreasing order.
manager_city_freq <- sort(manager_city_freq, decreasing=TRUE)
print(manager_city_freq)

#Changing parameters:
par(mar = c(8, 4, 4, 2))

#Create bar plot:
barplot(manager_city_freq,
        main = "Number of Managers by City",
        xlab = "City",
        ylab = "Number of Managers",
        col = "maroon",
        las = 2,)


#b. - Create a second bar plot showing the rate of high-hours managers by city, ordered in decreasing order.

#Changing New York to NY so the plot is readable.
managers_new_merged$city[managers_new_merged$city == "New York"] <- "NY"
print(managers_new_merged$city)

#Creating frequency table for high-hours and city:
manager_city_hours_rates <- tapply(managers_new_merged$high_hours_flag=="Y", 
                                   managers_new_merged$city, 
                                   mean)
print(manager_city_hours_rates)                                    

#Changing parameters/margins:
par(mar=c(8,4,4,2))

#Create bar plot:
barplot(manager_city_hours_rates,
        main = "Rate of High-Hour Managers by City",
        xlab = "City",
        ylab = "Proportion of High-Hour Managers",
        col = "aquamarine",
        las = 2)


#c. - Which city has the most managers? Which city has the highest share of high-hours managers? Do the two rankings align?

manager_most_city <- table(managers_new_merged$city)
manager_most_city <- sort(manager_city_freq, decreasing = TRUE)
print(manager_most_city)
#The city with the most managers is Toronto.

#8 - Scatter Plot & Correlation

#a. Create a scatter plot between the test score and the number of years employed.

scatter.smooth(managers_new_merged$yrs_employed,
               managers_new_merged$test_score,
               main= "Test Score vs Years Employed",
               xlab= "Years Employed",
               ylab= "Test Score",
               col= "pink"
)


#b. Calculate and interpret the correlation coefficient of this association. Do managers with more years of experience tend to have higher test scores?

#Calculating the correlation coefficient of the association.
cor_coe_yrs_test <- cor(managers_new_merged$yrs_employed,
                        managers_new_merged$test_score)
print(cor_coe_yrs_test)

#Interpretation: The r value is 0.0098 which is very close to 0. Showing no linear relationship between years employed and test scores. Years of experience and test scores are not correlated.

#Experience = Test Score: Based on the data we can see that just because a manager has more years of experience does not mean that they will have a higher test score. 

#9 - Linear Regression: Predicting Test Score

#a. - Perform a linear regression to predict the test score based on the number of years employed, number of customers, and group size.

#Perform Linear Regression

model <- lm(test_score ~ yrs_employed + customers + group_size,data = managers_new_merged)
summary(model)

#b. - Interpret the regression coefficients: how does each predictor affect test scores?

# The intercept (201.27) shows the predicted test score when yrs_employed, customers, and group_size are all equal to zero. It is the general baseline for the regression model. 

# The coefficient for yrs_employed is -3.664, which shows that there is a 3.66 point decrease in the predicted test score for every year of employment. This is not significant because the P value is (P = 0.352),  which is higher than 0.05 for us to consider it statistically significant.

# The coefficient for customers is -0.532, which shows there is a 0.53 point decrease in predicted test score for each additional customer added to an employee. This is not significant because the P value is (P = 0.436),  which is higher than 0.05 for us to consider it statistically significant.

# The coefficient for group size is 5.661, which shows that each additional person in a group is associated with a 5.66 point increase in the predicted test score. This is significant because the P value is (P < 0.001),  which is lower than 0.05, which makes it statistically significant.

#c. - Predict the expected test score for a manager with 10 years of employment, 20 group size, and 25 customers.

predict(model, newdata = data.frame(yrs_employed = 10, customers = 25, group_size = 20))

#Expected test score for a manager with 10 years of employment, 20 group size, and 25 customers is 264.5452 




#d. - Create a residuals plot. Does it show an absence of pattern?

scatter.smooth(model$fitted.values, model$residuals,
               xlab = "Fitted Values",
               ylab = "Residuals",
               main = "Residuals vs Fitted Values",
               col = "red")


#There is a general absence of pattern and no apparent curvature.

#10 - You have been guided through specific tasks. Now it is your turn to be creative:

#a. - Choose and state a question of interest related to the manager dataset and decide on an appropriate method of analysis (e.g., summary statistics, visualization, correlation, regression, or a combination).

#Does a manager's concern flag status relate to their bonus score and years employed?

#In other words, do managers who have been flagged for concern tend to have lower bonus scores and fewer years of experience compared to non-flagged managers?

#Method: Summary statistics (mean comparison) + side-by-side boxplots + bar plot.

#b. - Perform the analysis and present your results (include plots or tables as appropriate).

# PART 1: Average Bonus Score by Concern Flag

#Compute average bonus score for flagged vs. non-flagged managers
avg_bonus_concern <- aggregate(bonus_score ~ concern_flag,
                               data = managers_new_merged,
                               FUN = mean)
print("Average Bonus Score by Concern Flag:")
print(avg_bonus_concern)

#Compute average years employed for flagged vs. non-flagged managers
avg_yrs_concern <- aggregate(yrs_employed ~ concern_flag,
                             data = managers_new_merged,
                             FUN = mean)
print("Average Years Employed by Concern Flag:")
print(avg_yrs_concern)

#Count of flagged vs. non-flagged managers
concern_counts <- table(managers_new_merged$concern_flag)
print("Count of Managers by Concern Flag:")
print(concern_counts)

#PART 2: Boxplot - Bonus Score by Concern Flag

boxplot(bonus_score ~ concern_flag,
        data = managers_new_merged,
        main = "Bonus Score by Concern Flag",
        xlab = "Concern Flag (N = No, Y = Yes)",
        ylab = "Bonus Score",
        col = c("lightblue", "coral"))


#PART 3: Boxplot - Years Employed by Concern Flag

boxplot(yrs_employed ~ concern_flag,
        data = managers_new_merged,
        main = "Years Employed by Concern Flag",
        xlab = "Concern Flag (N = No, Y = Yes)",
        ylab = "Years Employed",
        col = c("lightgreen", "orange"))


#PART 4: Bar Plot - Concern Flag Rate by Performance Group

#Calculate the proportion of concern-flagged managers per performance group
concern_rate <- tapply(managers_new_merged$concern_flag == "Y",
                       managers_new_merged$performance_group,
                       mean)
print("Concern Flag Rate by Performance Group:")
print(concern_rate)

#Sort in decreasing order
concern_rate_sorted <- sort(concern_rate, decreasing = TRUE)

#Adjust margins so labels fit
par(mar = c(8, 4, 4, 2))

barplot(concern_rate_sorted,
        main = "Rate of Concern-Flagged Managers by Performance Group",
        xlab = "Performance Group",
        ylab = "Proportion Flagged",
        col = "tomato",
        las = 2)


#c. - Interpret your results: What did you learn from this analysis that could be useful for HR decision-making?

#The analysis shows that concern-flagged managers (Y) tend to have slightly lower average bonus scores compared to non-flagged managers (N). The boxplots confirm this gap, with flagged managers showing a tighter, lower distribution of bonus scores.

#Regarding years employed, concern-flagged managers actually tend to have fewer years of experience on average, suggesting that newer managers may be more prone to being flagged for concerns — possibly due to less familiarity with company expectations or processes.

#The bar plot reveals that the Bottom performance group has the highest concern flag rate, which is expected, while the Top group has the lowest rate.

#HR Action: These findings suggest that HR should prioritize early support and mentorship programs for newer managers (lower yrs_employed), as they are more likely to be flagged. Additionally, since flagged managers also tend to score lower on bonuses, targeted training and performance coaching for concern-flagged individuals could help improve both their standing and their reward outcomes.


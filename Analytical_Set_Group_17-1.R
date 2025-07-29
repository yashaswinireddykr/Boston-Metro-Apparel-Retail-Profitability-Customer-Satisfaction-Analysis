#Loading necessary packages
library(readxl)
library(writexl)
library(moments) # for skewness
library(ggplot2) # for plots
library(dplyr)

# Load the datasets
sales_data <- sales
customers_data <- customers

# View the data
head(sales_data)
head(customers_data)

# Check column names
colnames(sales_data)
colnames(customers_data)

#Part A starting
# Cleansing customer data set columns
# Cleansing customer state column
unique(customers_data$customer.state)
customers_data$customer.state[customers_data$customer.state == "Mass."] <- "MA"
customers_data$customer.state[customers_data$customer.state == "Massachusetts"] <- "MA"
customers_data$customer.state[customers_data$customer.state == "Mass"] <- "MA"
customers_data$customer.state[customers_data$customer.state == "Massachusets"] <- "MA"
customers_data$customer.state[customers_data$customer.state == "Connecticut"] <- "CT"
customers_data$customer.state[customers_data$customer.state == "Conn."] <- "CT"

# Cleansing selection satisfaction column
#Replace empty or missing values in the selection column with NA
customers_data$selection[customers_data$selection == "" | is.na(customers_data$selection)] <- NA
summary(customers_data$selection)                            

# Cleansing birthday.month
unique(customers_data$birthday.month)
customers_data$birthday.month[customers_data$birthday.month == "October"] <- "10"
customers_data$birthday.month[customers_data$birthday.month == "March"] <- "3"
customers_data$birthday.month[customers_data$birthday.month == "Mar"] <- "3"
customers_data$birthday.month[customers_data$birthday.month == "February"] <- "2"
customers_data$birthday.month[customers_data$birthday.month == "Apr."] <- "4"
customers_data$birthday.month[customers_data$birthday.month == "Feb."] <- "2"
customers_data$birthday.month[customers_data$birthday.month == "April"] <- "4"
customers_data$birthday.month[customers_data$birthday.month == "Nov."] <- "11"
customers_data$birthday.month[customers_data$birthday.month == "July"] <- "7"
customers_data$birthday.month[customers_data$birthday.month == "Oct"] <- "10"
customers_data$birthday.month[customers_data$birthday.month == 0] <- NA        
customers_data <- customers_data[!is.na(customers_data$birthday.month), ]

# Checking the unique values throughout the customer dataset
unique(customers_data$customer.state)
unique(customers_data$birthday.month)
unique(customers_data$age)
unique(customers_data$years.as.member)
unique(customers_data$in.store.exp)
unique(customers_data$selection)

# To check numerical columns from the dataset
numerical_columns <- sapply(customers_data, is.numeric)
names(customers_data)[numerical_columns] 

# Aggregate the sales data to calculate count and average sale amount for each customer
summary_table <- sales_data %>%
  group_by(customer.id) %>%
  summarize(
    total_items_purchased = n(),  # Count of transactions/items
    avg_item_sale_price = mean(sale.amount, na.rm = TRUE)  # Average sale amount
  )

# Merge with the cleaned customer data
customer_purchases <- left_join(summary_table, customers_data, by = "customer.id")

write.csv(customer_purchases, "customer_purchases.csv", row.names = FALSE)
write_xlsx(customer_purchases, "customer_purchases.xlsx")

mean_sale <- mean(sales_data$sale.amount, na.rm = TRUE)  # Mean
median_sale <- median(sales_data$sale.amount, na.rm = TRUE)  # Median
sd_sale <- sd(sales_data$sale.amount, na.rm = TRUE)  # Standard Deviation
skew_sale <- skewness(sales_data$sale.amount, na.rm = TRUE)

# Boxplot for all sale amounts
ggplot(sales_data, aes(y = sale.amount)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  ggtitle("Boxplot of Sale Amounts for All Sales") +
  ylab("Sale Amount") +
  theme_minimal()

# Boxplot for sale amount separately for each product category
ggplot(sales_data, aes(x = category, y = sale.amount, fill = category)) +
  geom_boxplot() +
  ggtitle("Boxplot of Sale Amounts by Product Category") +
  ylab("Sale Amount") +
  xlab("Product Category") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# Blended Gross Margin Calculation for each Product Category
gross_margin_by_category <- sales_data %>%
  group_by(category) %>%
  summarise(
    total_sale_amount = sum(sale.amount, na.rm = TRUE),
    total_ext_cost = sum(ext.cost, na.rm = TRUE),
    blended_gross_margin = (total_sale_amount - total_ext_cost) / total_sale_amount * 100
  )

# Display the results
print(gross_margin_by_category)


#Finding outliers using boxplot
ggplot(sales_data, aes(y = sale.amount)) +
  geom_boxplot(fill = "skyblue", color = "black") +
  ggtitle("Boxplot of Sale Amounts") +
  ylab("Sale Amount") +
  theme_minimal()
#Finding outliers using z scores
z_scores <- scale(sales_data$sale.amount)
outliers_z_score <- sales_data[abs(z_scores) > 3, ]

#Part 2:Statistical Inference
#Hypothesis testing
#Null Hypothesis (H₀):There is no significant difference in the gross margin percentage (GM%) across the four seasons (Winter, Spring, Summer, Fall).
#Alternative Hypothesis (H₁):There is a significant difference in the gross margin percentage (GM%) across the four seasons.
str(sales_data)
sales_data$date <- as.Date(sales_data$sale.date, format = "%Y-%m-%d")
sales_data$month <- as.numeric(format(sales_data$date, "%m"))

# Categorizing months into seasons
sales_data$season <- ifelse(sales_data$month %in% c(12, 1, 2), "Winter",  # Dec, Jan, Feb = Winter
                            ifelse(sales_data$month %in% c(3, 4, 5), "Spring",  # Mar, Apr, May = Spring
                                   ifelse(sales_data$month %in% c(6, 7, 8), "Summer",  # Jun, Jul, Aug = Summer
                                          "Fall")))  # Sep, Oct, Nov = Fall

# Calculating Gross Margin Percentage (GM%) for each transaction
sales_data <- sales_data %>%
  mutate(gross_margin_percentage = gross.margin / unit.original.retail)

# Performing the hypothesis test (ANOVA) for GM% across Winter, Spring, Summer, and Fall
anova_result <- aov(gross_margin_percentage ~ season, data = sales_data)

# Print the ANOVA result
print(summary(anova_result))

# Conclusion based on the p-value
anova_p_value <- summary(anova_result)[[1]]$`Pr(>F)`[1]  # Extract p-value

if(anova_p_value < 0.05) {
  print("Reject the null hypothesis: There is a significant difference in GM% across the seasons.")
} else {
  print("Fail to reject the null hypothesis: There is no significant difference in GM% across the seasons.")
}

#Regression
price_category_dummies <- model.matrix(~ price.category - 1, data = sales_data)
category_dummies <- model.matrix(~ category - 1, data = sales_data)

interaction_terms_price <- sales_data$sale.amount * price_category_dummies
interaction_terms_category <- sales_data$sale.amount * category_dummies
sales_data <- cbind(sales_data, interaction_terms_price, interaction_terms_category)
model <- lm(gross.margin ~ sale.amount + ext.cost + category + price.category +
              loyalty.member + interaction_terms_price + interaction_terms_category, 
            data = sales_data)
summary(model)

summary_model <- summary(model)
# Extract the coefficients table
coefficients_table <- summary_model$coefficients
# View the coefficients table
print(coefficients_table)
write.csv(coefficients_table, "model_summary.csv")
write_xlsx(as.data.frame(summary(model)$coefficients), "model_summary.xlsx")

library(haven)
library(dplyr)
library(ggplot2)
library(margins)

# Load data
data <- read_sav("Downloads/elmps 2018 xs v2.0 all.sav")

subjects <- data %>%
  filter(q12204==1, q12205==1) %>%
  mutate(q12207 = case_when(
    q12207 == 1 ~ "Public financial institution",
    q12207 == 2 ~ "Public financial institution",
    q12207 == 3 ~ "Public financial institution",
    q12207 == 4 ~ "Private banks",
    q12207 == 5 ~ "NGOs",
    q12207 == 6 ~ "Private sector companies",
    TRUE ~ "Other" 
  ),
  uses_fin_inst = case_when(
    q12207 %in% c("Public financial institution", "Private banks") ~ TRUE,
    TRUE ~ FALSE
  ),
  education = case_when(
    educ == 1 ~ "Illiterate",
    educ == 2 ~ "Reads & Writes",
    educ == 3 ~ "Less than Intermediate",
    educ == 4 ~ "Intermediate",
    educ == 5 ~ "Above Intermediate",
    educ == 6 ~ "University",
    educ == 7 ~ "Post-Graduate",
    TRUE ~ "Other" 
  ),
  sex = case_when(
    sex == 1 ~ "Male",
    sex == 2 ~ "Female"
  ),
  agesq = age ^ 2,
  urban = case_when(
    urban == 1 ~ "Urban",
    urban == 2 ~ "Rural"
  ),
  urban_nr = case_when(
    urban == "Urban" ~ 1,
    urban == "Rural" ~ 0
  ),
  educ_level = case_when(
    educ >= 6 ~ "Tertiary",
    TRUE ~ "Secondary"
  ),
  wealth_bin = cut(wealth, ##USED CHATGPT HERE
                   breaks = quantile(wealth, probs = seq(0, 1, by = 0.2), na.rm = TRUE), 
                   labels = c("Lowest 20%", "20-40%", "40-60%", "60-80%", "Top 20%"),
                   include.lowest = TRUE))


## WHO USES BORROWING MECHANISMS
borrowing_prop <- sum(data$q12204 == 1 & data$q12205 == 1, na.rm = TRUE) / sum(data$round == 2018, na.rm = TRUE)

borrowing_anzahl <- sum(data$q12204 == 1 & data$q12205 == 1, na.rm = TRUE)

## averages and standard deviations
averages <- subjects %>%
  select(uses_fin_inst, age, wealth, educ, sex, urban_nr) %>%
  summarise(
    absolute = n(),
    avg_age = mean(age),
    avg_wealth = mean(wealth),
    avg_educ = mean(educ),
    avg_uses_fin_inst = mean(uses_fin_inst),
    avg_urban = mean(urban_nr),
    sd_age = sd(age),
    sd_wealth = sd(wealth),
    sd_educ = sd(educ),
    sd_uses_fin_inst = sd(uses_fin_inst),
    sd_urban = sd(urban_nr)
  )



# LOGIT regression model + marginal effects
logit_model <- glm(uses_fin_inst ~ sex + educ_level + urban + wealth_bin + age + agesq, 
                   data = subjects, 
                   family = binomial)
summary(logit_model)
marginal_effects <- margins(logit_model)
summary(marginal_effects)

# Baseline regression model
baseline_logit_model <- glm(uses_fin_inst ~ sex + educ_level + wealth_bin + age + agesq, 
                   data = subjects, 
                   family = binomial)
summary(baseline_logit_model)
marginal_effects <- margins(baseline_logit_model)
summary(marginal_effects)

# Odds ratios baseline model (alternative way to view coefficients)
exp(coef(baseline_logit_model))

# Odds ratios logit model (alternative way to view coefficients)
exp(coef(logit_model))


# PROBIT regression model + marginal effects
probit_model_borrowing <- glm(uses_fin_inst ~ educ_level + sex + urban + wealth_bin + age + agesq, 
                           data = subjects, 
                           family = binomial(link = "probit"))
summary(probit_model_borrowing)
marginal_effects <- margins(probit_model_borrowing)
summary(marginal_effects)

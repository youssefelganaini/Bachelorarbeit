  library(haven)
  library(dplyr)
  library(ggplot2)
  library(margins)
  
  # Load data (elmps 2018 xs v2.0 all)
  data <- read_sav("Downloads/elmps 2018 xs v2.0 all.sav")
  
  subjects <- data %>%
    filter(q12201==1) %>%
    mutate(q12202 = case_when(
      q12202 == 1 ~ "Public financial instituion",
      q12202 == 2 ~ "Public financial instituion",
      q12202 == 3 ~ "Public financial instituion",
      q12202 == 4 ~ "Private Bank",
      q12202 == 5 ~ "Cash",
      q12202 == 6 ~ "Gold",
      q12202 == 7 ~ "Other",
      q12202 == 8 ~ "Real Estate",
      TRUE ~ "Other" 
    ),
    uses_fin_inst = case_when(
      q12202 %in% c("Public financial institution", "Private Bank") ~ TRUE,
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
    agesq = age ^ 2,
    sex = case_when(
      sex == 1 ~ "Male",
      sex == 2 ~ "Female"
    ),
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
  
  
  ## Amount of people who use saving mechanisms
  saving_anzahl <- sum(data$q12201 == 1, na.rm = TRUE)
  
  ## AVERAGES (used for the table)
  summary_table <- subjects %>%
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
  
  # Logistic regression model + marginal effects
  logit_model <- glm(uses_fin_inst ~ sex + educ_level + urban + wealth_bin + age + agesq, 
                     data = subjects, 
                     family = binomial)
  summary(logit_model)
  marginal_effects <- margins(baseline_logit_model)
  summary(marginal_effects)

  
  # Baseline regression model + marginal effects
  baseline_logit_model <- glm(uses_fin_inst ~ sex + educ_level + wealth_bin + age + agesq, 
                              data = subjects, 
                              family = binomial)
  summary(baseline_logit_model)
  marginal_effects <- margins(logit_model)
  summary(marginal_effects)

  
  # Odds ratios baseline model (alternative way to view coefficients)
  exp(coef(baseline_logit_model))
  
  # Odds ratios logit model (alternative way to view coefficients)
  exp(coef(logit_model))
  
  # PROBIT regression model + marginal effects
  probit_model_saving <- glm(uses_fin_inst ~ educ_level + sex + urban + wealth_bin + age + agesq, 
                             data = subjects, 
                             family = binomial(link = "probit"))
  summary(probit_model_saving)
  marginal_effects <- margins(probit_model_saving)
  summary(marginal_effects)

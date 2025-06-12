# Abstract

Enabling financial access to unbanked and financially underserved segments of the population remains an important challenge in emerging markets. In Egypt, financial inclusion is an important element of the Central Bank’s long-term national strategy. This study investigates the underlying determinants of formal financial institution usage in Egypt with a specific focus on predicting formal saving and borrowing. We use the fourth wave of the Egyptian Labor Market Panel Survey, a nationally representative survey covering a wide range of topics. Using logistic regression, we find that for saving, being male, attaining tertiary education, residing in urban areas as well as belonging to higher wealth quantiles are all significant predictors. Being male, attaining tertiary education and age are significant for formal borrowing. Our results suggest policy implications, including addressing the gender wealth gap and embracing financial technology solutions to enhance financial access.

# Code 
We use data from the 2018 wave of the Egyptian Labor Market Panel Survey (ELMPS), a nationally representative survey conducted in Egypt. The dataset includes detailed information on demographics, labor market status, education, and financial behavior.

For our analysis, we focus on two subsets:

1. Savings behavior: Individuals who reported saving in the past year (q12201 == 1), and the type of saving mechanism used (q12202), classified into formal (e.g., public financial institutions, private banks) and informal mechanisms.

2. Borrowing behavior: Individuals who borrowed in the past year (q12204 == 1) and whose loans are still outstanding (q12205 == 1). The loan source (q12207) is similarly categorized into formal and informal financial institutions.

We create binary outcome variables indicating whether respondents used formal financial institutions for saving or borrowing. Key predictors include gender, education level, age, urban residence, and wealth quintiles. The wealth variable is binned into quintiles based on national distribution.

Regression analysis (logit and probit models) and marginal effects estimation are conducted to investigate the relationship between these demographic and socioeconomic characteristics and formal financial institution usage

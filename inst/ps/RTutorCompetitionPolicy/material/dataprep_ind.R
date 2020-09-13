# Data prep industrial policy
library(haven)
library(dplyr)

raw <- read_dta("replication_Nov_10_2014.dta")
dat3 <- raw %>% 
  filter(domprivate == 1) %>%
  mutate_at(vars(year, idnew, sectoridnew, countycode_4digit, sectorid2digit, domprivate), as.character) %>%
  mutate(competition = competition_lerner,
         competition_square = competition^2)

# In Work
dat3 <- select(dat3, id = idnew,
               industry = sectoridnew,
               county = countycode_4digit,
               year,
               tfp = TFP_OP_all,
               index_subsidy,
               index_tax,
               index_interest,
               interestratio,
               tariff,
               competition,
               competition_square,
               cor_subsidy = cor_subsidy_lerner,
               cor_tax = cor_tax_lerner,
               cor_interest = cor_interest_lerner,
               cor_tariff = cor_tariff_lerner,
               compherf_subsidy = comp_herfsubsidy,
               compherf_tax = comp_herftax,
               compherf_interest = comp_herfinterest,
               exportshare_industry = exportshare_sector,
               stateshare,
               horizontal,
               backward,
               forward,
               lnTariff,
               lnbwTariff,
               lnfwTariff,
               compherf_subsidy_size = comp_herfsubsidy_weightsize,
               compherf_tax_size = comp_herftax_weightsize,
               compherf_interest_size = comp_herfinterest_weightsize,
               compherf_subsidy_age = comp_herfsubsidy_weightage,
               compherf_tax_age = comp_herftax_weightage,
               compherf_interest_age = comp_herfinterest_weightage)

saveRDS(dat3, file = "dat3.RDS")

#col = colorRampPalette(c("#BB4444", "#EE9988", "#FFFFFF", "#77AADD", "#4477AA"))

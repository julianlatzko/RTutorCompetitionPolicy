library(dplyr)

raw <- read.table("BCDVS_95_4_2013_estimation_data.tab", header = TRUE, sep = "\t")
raw <- select(raw, 
              id = identif, 
              industry = isicrev3, 
              country = iso_code, 
              year,
              cpi = compindex,
              tfp = tfpcorrectedoverklems, 
              tfpleader = tfpleadershipklems,
              tecgap = tecnogapklems,
              trade = tradelib,
              imports = impo,
              pmr,
              trend = ind_trend,
              pcm = pcmpoolklems,
              valuerealppp = valurealklemsppp,
              valuereal = valurealklems,
              institutions = inst,
              enforcement = enf,
              antitrust,
              mergers,
              per108,
              per403,
              per404,
              per505,
              isic)

# Convert numerics to factors
raw <- mutate_at(raw, vars(year, id, industry, country), as.character)

# Lagging variables for the main regression
main <- raw %>% group_by(id) %>%
        mutate(cpi = lag(cpi, n = 1, order_by = year),
               tecgap = lag(tecgap, n = 1, order_by = year),
               trade = lag(trade, n = 1, order_by = year),
               pmr = lag(pmr, n = 1, order_by = year),
               institutions = lag(institutions, n = 1, order_by = year),
               enforcement = lag(enforcement, n = 1, order_by = year),
               antitrust = lag(antitrust, n = 1, order_by = year),
               mergers = lag(mergers, n = 1, order_by = year),
               per108 = lag(per108, n = 1, order_by = year),
               per403 = lag(per403, n = 1, order_by = year),
               per404 = lag(per404, n = 1, order_by = year),
               per505 = lag(per505, n = 1, order_by = year)) %>%
        ungroup()

comp <- select(main, id, year, tfp, cpi, tfpleader, tecgap, trade, pmr, trend)
main <- main[complete.cases(comp), ]

# Discarding extreme outliers for TFP (~1st and 99th percentile, 1847 Obs.)
main <- filter(main, tfp > -0.282 & tfp < 0.281 & pcm > 0.5 & pcm < 3.0)

## dat2.RDS without trade
dat <- select(main, id, industry, country, year, cpi, tfp, tfpleader, tecgap, pmr, trend, 
              institutions, enforcement, antitrust, mergers, per108, per403, per404, per505, 
              isic)
saveRDS(dat, file = "dat.RDS")

### dat2.RDS with trade
dat2 <- select(main, id, industry, country, year, cpi, tfp, tfpleader, tecgap, trade, pmr, trend, 
              institutions, enforcement, antitrust, mergers, per108, per403, per404, per505, 
              isic)
saveRDS(dat2, file = "dat2.RDS")

### raw data file to compute trade variable in ps
r = raw %>%
  group_by(id) %>%
  mutate(limports = lag(imports, n = 1L, order_by = year),
         lvaluerealppp = lag(valuerealppp, n = 1L, order_by = year)) %>%
  ungroup()

r = mutate(r, imports = if_else(year == 2004, limports, imports),
          valuerealppp = if_else(year == 2004, lvaluerealppp, valuerealppp))

r = select(r, id, year, imports, valuerealppp)
# Convert numerics to factors
r <- mutate_at(r, vars(year, id), as.character)
saveRDS(r, file = "raw.RDS")

###
r = readRDS("raw.RDS")
r =  mutate(r, trade_check = imports / valuerealppp)

r = r %>%
  group_by(id) %>%
  mutate(trade_check = lag(trade_check, n = 1L, order_by = year)) %>%
  ungroup()

dat = left_join(dat, r)
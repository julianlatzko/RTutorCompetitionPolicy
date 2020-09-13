isicrev <- c("01-05", "10-14", "15-16", "17-19", "20", "21-22", "23", "24", "25", "26",   
"27-28", "29", "30-33", "34-35", "36-37", "40-41", "45", "55", "60-63", "64", "65-67"
,"71-74")

indust <- c("Agriculture, Hunting, Forestry and Fishing",
            "Mining and Quarrying",
            "Manufacture of food products, beverages and tobacco products",
            "Manufacture of textiles, wearing apparel, tanning and dressing of leather",
            "Manufacture of wood, wood products and cork, except furniture",
            "Manufacture of paper and paper products; publishing, printing of media",
            "Manufacture of coke, refined petroleum products and nuclear fuel",
            "Manufacture of chemicals and chemical products",
            "Manufacture of rubber and plastics products",
            "Manufacture of other non-metallic mineral products",
            "Manufacture of metals, fabricated metal products; except machinery",
            "Manufacture of machinery and equipment",
            "Manufacture of computing machinery, electrical machinery, communication equipment, etc.",
            "Manufacture of motor vehicles, transport equipment",
            "Manufacture of furniture; recycling",
            "Electricity, gas and water supply",
            "Construction",
            "Hotels and restaurants",
            "Transport, storage and communications",
            "Post and telecommunications",
            "Financial intermediation, Insurance and pension funding",
            "Real estate, renting and business activities"
            
)

descrip <- data.frame(isicrev, indust)

# Structure of the CPI and its weights for treemaps
# Top-level CPIs
cpi_top <- data.frame(group = c(rep("Antitrust", 3), "Mergers"),
                      subgroup = c("Hardcore Cartels", "Abuses", "Other Agreements", "Mergers"),
                      weight = c(rep(1/3, 3), 1/3))

# Medium-level indexes - Hardcore Cartels
cartels <- data.frame(group = c(rep("Institutions", 5), rep("Enforcement", 2)),
                      subgroup = c("Independence", "Separation of Powers", "Quality of the Law", 
                                   "Powers during Investigations", "Sanctions and Damages", "Resources", " Sanctions and Cases"),
                      weight = c(rep(1/6, 4), 1/3, 1/3, 1/6))

# Low-level indexes - Enforcement Features - Hardcore Cartels
cartels_enf <- data.frame(group = c(rep("Resources", 3), rep("Cases", 2)),
                          subgroup = c("Budget", "Staff", "Staff Skills", "Number of open cases", "Maximum jail term imposed"),
                          weight = c(1/2, 1/4, 1/4, 1/6, 1/3))


# Low-level indexes - Institutional Features - Hardcore Cartels
cartels_inst <- data.frame(group = c(rep("Independence", 2), rep("Separation of Powers", 2), rep("Quality of the Law", 2), "Powers during Investigations", rep("Sanctions and Damages", 3)),
                           subgroup = c("Nature of prosecutor", "Nature of adjudicator and role of government", 
                                        "Separation between adjudicator and prosecuter", "Nature of appeal court", 
                                        "Standard of proof and goals that inform decision", "Leniency programm", "Combination of powers", "Sanction to firms", "Sanction to individuals", "Private actions"),
                           weight = c(rep(1/2, 2), 2/3, 1/3, rep(1/2, 2), 1, rep(2/3, 3)))

cpis <- list(cpi_top = cpi_top, 
             cartels = cartels, 
             cartels_enf = cartels_enf, 
             cartels_inst = cartels_inst)
saveRDS(cpis, "cpis.rds")
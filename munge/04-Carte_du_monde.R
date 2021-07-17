monde <- rnaturalearth::ne_download() %>% 
  st_as_sf() %>%
  filter(POP_EST > 0,
         NAME != "Antarctica", 
         TYPE %in% c("Sovereign country", "Country")) %>%
  
  # Quelques pays n'ont pas de code ISO: Norvège, Somaliland, Kosovo, Chypre du Nord
  # On convertit ce qu'on peut et on élimine le reste
  mutate(ISO_A3_EH = case_when(!is.na(ISO_A3_EH) ~ ISO_A3_EH,
                               is.na(ISO_A3_EH) ~ countrycode(SOVEREIGNT, 
                                                              origin = "country.name",
                                                              destination = "iso3c"))) 

cache("monde")


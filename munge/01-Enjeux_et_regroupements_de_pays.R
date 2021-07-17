# Définition des enjeux pour les passer en boucle -------------------------------
enjeux <- tibble(
  court = c(
    "autre",
    "colonialisme",
    "desarmement",
    "dev_econ",
    "droit_pers",
    "moyen_orient",
    "nucleaire"
  ),
  long = c(
    "Autre",
    "Colonialisme",
    "Désarmement",
    "Développement économique",
    "Droits de la personne",
    "Moyen-Orient",
    "Nucléaire"
  )
)
cache("enjeux")

# Regroupements de pays --------------------------------------------------------
g7 <- c("Canada",
        "France",
        "Germany",
        "Italy",
        "Japan",
        "United Kingdom",
        "United States") %>%
  countrycode(., origin = "country.name", destination = "iso3c")

g20 <-
  c(
    "Argentina",
    "Australia",
    "Brazil",
    "Canada",
    "China",
    "France",
    "Germany",
    "India",
    "Indonesia",
    "Italy",
    "Japan",
    "Mexico",
    "Netherlands",
    "Russia",
    "Saudi Arabia",
    "Singapore",
    "South Africa",
    "South Korea",
    "Spain",
    "Switzerland",
    "Turkey",
    "United Kingdom",
    "United States"
  ) %>% countrycode(., origin = "country.name", destination = "iso3c")
cache("g7")
cache("g20")

# Pour l'Afrique sub-saharienne, on utilise la base de données du paquet countrycode
afr <- countrycode::codelist_panel %>%
  filter(year == 2020 &
           region == "Sub-Saharan Africa" & !is.na(iso3c)) %>%
  pull(iso3c) # dplyr::pull permet de retourner un vecteur
cache("afr")


# Pour les pays en développement, on génère un tableau de la
# Banque mondiale et on en extrait les pays en développement (il y en a 218)
if (!exists("pays")) {
  pays <- wb_countries() %>%
    filter(income_level != "Aggregates") %>%
    select(-c(capital_city, contains("_iso2c"), contains("admin_")))
  cache("pays")
}
dev <- pays %>%
  filter(income_level_iso3c != "HIC") %>%
  pull("iso3c")
lic <- pays %>%
  filter(income_level_iso3c == "LIC") %>%
  pull("iso3c")
lmic <- pays %>%
  filter(income_level_iso3c == "LMC") %>%
  pull("iso3c")
umic <- pays %>%
  filter(income_level_iso3c == "UMC") %>%
  pull("iso3c")

cache("dev")
cache("lic")
cache("lmic")
cache("umic")


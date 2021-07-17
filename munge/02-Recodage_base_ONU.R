

# Téléchargement de la base de données ----------------------------------------

# Ne faire qu'une seule fois
# download.file("https://dataverse.harvard.edu/dataset.xhtml?persistentId=hdl:1902.1/12379#", "./data/completeVotes.RData")
# load("./data/completeVotes.RData")


# Recodage des valeurs du tableau initial --------------------------------------
# On recode certaines valeurs et renomme les variables d'enjeux et de pays
onu <- completeVotes %>%
  mutate(vote_long = factor(
    vote,
    labels = c("Pour", "Abstention", "Contre", "Absent", "Non membre")
  )) %>%
  
  rename(
    moyen_orient = me,
    nucleaire = nu,
    desarmement = di,
    droit_pers = hr,
    colonialisme = co,
    dev_econ = ec,
    pays = Country,
    pays_long = Countryname
  ) %>%
  
  # On convertit les colonnes temporelles
  mutate(date = ymd(date)) %>%
  
  # On ajoute un enjeu "autre"
  mutate(
    nb_enjeux = (
      moyen_orient + nucleaire +
        desarmement +
        droit_pers +
        colonialisme +
        dev_econ
    ),
    autre = if_else(nb_enjeux == 0, 1, 0)
  ) %>%
  
  # On enlève les "votes" des non-membres et les résolutions identiques (3%)
  filter(vote != 9 & ident == 0) %>%
  
  # On mesure la proportion de votes "en faveur" des résolutions de l'AGNU tous
  # enjeux confondus par pays et par session.
  group_by(year, pays) %>%
  mutate(prop_oui = mean(vote_long == "Pour")) %>%
  ungroup() %>%
  
  # On reformate le tableau le tableau en y enlevant les variables redondantes
  select(
    resid,
    vote_long,
    year,
    pays,
    prop_oui,
    importantvote,
    short,
    moyen_orient,
    nucleaire,
    desarmement,
    droit_pers,
    colonialisme,
    dev_econ,
    autre,
    nb_enjeux,
    everything(),-rcid,
    -amend,
    -member,
    -ccode,
    -ident
  )

# Création d'un tableau synthétisant les résolutions --------------------------
td_resolutions <- onu %>%
  select(-c(vote, vote_long, pays, pays_long, starts_with("prop"))) %>%
  group_by(resid) %>%
  slice_head(n = 1) %>%
  ungroup

cache("td_resolutions")

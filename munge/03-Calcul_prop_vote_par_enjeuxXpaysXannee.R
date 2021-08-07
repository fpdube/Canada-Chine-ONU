# On cherche à savoir dans quelle proportion chaque pays a voté pour chaque enjeu
# à chaque année. 

fn_prop_enjeux <- function(df, .enjeu) {
  # Cette fonction passe programmatiquement chaque enjeu et en calcule le
  # taux de vote positif
  df %>%
    group_by(year, pays) %>%
    summarize(
      !!sym(str_c("prop_", .enjeu)) :=
        sum((vote_long == "Pour") * !!sym(.enjeu)) / sum(!!sym(.enjeu))
    )
}

td_resumes <-
  # map crée une liste de tableaux...
  map(~ fn_prop_enjeux(onu, .enjeu = .x), .x = enjeux$court) %>% 
  
  # ... qu'on fusionne en un tableau (de tableaux) avec la fonction purrr::reduce ...
  reduce(inner_join, by = c("year", "pays"))

# ... et qu'on réintègre dans onu
onu <-
  onu %>%
  left_join(., td_resumes, by = c("year", "pays"))

cache("onu")

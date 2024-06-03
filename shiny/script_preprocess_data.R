# Pour accélérer le fonctionnement du dashboard on utilise un fichier sans
# les doublons déjà crée.

df <- read_csv("../data/data_1_200000.csv")

dfDuplicates <- df[duplicated(df),] # stock les doublons dans un objet
df <- unique(df) # retire les doublons au dataset df
nbrRepository <- dim(df)[1]
nbrAttributes <- dim(df)[2]

write_csv(df, "../data/data_1_200000_noDuplicates.csv")

# ===== Zone pour faire des test ========

repoNameList <- df$name
pattern <- paste(".*","free", sep="")
matchingList <- grep(pattern, repoNameList, value = TRUE)
matchingList
# load2.r 
# This script loads the data and cleans it. It is a copy of `load.r`, which was
# used for posts 1-5, but modified to clean the data more rigorously. It is also
# better optimized. I have two load scripts so that results from the earlier
# posts are preserved unmodified.

library(dplyr)
library(stringr)

# Read the historical history dissertations data
raw <- read.csv("data/history-df.csv", stringsAsFactors=F)

# Turn import into a tbl_df to make it easier to work with dplyr
raw <- tbl_df(raw)

# Turn empty strings into NAs
raw[raw == ""] <- NA

# Figure out the universities outside of the U.S. and Canada to drop
# universities <- raw %.%
#   group_by(university) %.%
#   summarise(count = length(id)) %.%
#   arrange(university)
# 
# write.csv(universities, "temp/universities.csv")

# Universities to delete
universities_to_delete <- c(
  "Adelphi University, School of Social Work.",
  "Adelphi University, The Institute of Advanced Psychological Studies.",
  "Adler School of Professional Psychology.",
  "Ahmadu Bello University (Nigeria).",
  "Allegheny University of Health Sciences.",
  "American Conservatory of Music.",
  "American School of Professional Psychology - Rosebridge.",
  "American Conservatory of Music.",
  "American School of Professional Psychology - Rosebridge.",
  "Bar-Ilan University (Israel).",
  "Bogazici Universitesi (Turkey).",
  "Boston University School of Education.",
  "Brandeis University, The Heller School for Social Policy and Management.",
  "Brandenburgische Technische Universitaet Cottbus (Germany).",
  "Bryn Mawr College, Graduate School of Social Work and Social Research.",
  "Cairo University (Egypt).",
  "Caribbean Graduate School of Theology (Jamaica).",
  "Case Western Reserve University (Health Sciences).",
  "Centro de Estudios Avanzados de Puerto Rico y el Caribe (Puerto Rico).",
  "Christian-Albrechts Universitaet zu Kiel (Germany).",
  "Chuo Daigaku (Japan).",
  "Columbia University Teachers College under the Faculty of Union Theological Seminary in the City of New York.",
  "Duquesne University School of Nursing.",
  "Eberhard Karls Universitaet Tuebingen (Germany).",
  "Ecole des Hautes Etudes en Sciences Sociales (France).",
  "Erasmus Universiteit Rotterdam (The Netherlands).",
  "Fletcher School of Law and Diplomacy (Tufts University).",
  "Flinders University of South Australia (Australia).",
  "Florida Agricultural and Mechanical University.",
  "Freie Universitaet Berlin (Germany).",
  "Goteborgs Universitet (Sweden).",
  "Griffith University (Australia).",
  "Hitotsubashi University (Japan).",
  "Hong Kong Baptist University (Hong Kong).",
  "Hong Kong Polytechnic University (Hong Kong).",
  "Hong Kong University of Science and Technology (Hong Kong).",
  "Humanistic Psychology Institute.",
  "Indiana University, Kelley School of Business.",
  "Institute for Clinical Social Work (Chicago).",
  "Institute of Transpersonal Psychology.",
  "International Baptist Theological Seminary of the European Baptist Federation (Czech Republic).",
  "International Christian University (Japan).",
  "International Marian Research Institute.",
  "Istanbul Teknik Universitesi (Turkey).",
  "Japan Women's University (Japan).",
  "Johannes Gutenberg-Universitaet Mainz (Germany).",
  "Jouchi Daigaku (Japan).",
  "Kanazawa University (Japan).",
  "Karlsruher Institut fuer Technologie, Universitaet Karlsruhe (TH) (Germany).",
  "Katholieke Universiteit Leuven (Belgium).",
  "Keio University (Japan).",
  "King Fahd University of Petroleum and Minerals (Saudi Arabia).",
  "Kokugakuin University (Japan).",
  "La Trobe University (Australia).",
  "Leopold-Franzens Universitaet Innsbruck (Austria).",
  "Linkopings Universitet (Sweden).",
  "London School of Economics and Political Science (United Kingdom).",
  "Louisiana State University Health Sciences Center School of Nursing.",
  "MGH Institute of Health Professions.",
  "Maharishi University of Management.",
  "Makerere University (Uganda).",
  "Manchester Business School (United Kingdom).",
  "Manhattan School of Music.",
  "Massachusetts School of Professional Psychology.",
  "Massey University (New Zealand).",
  "Medical University of South Carolina - College of Health Professions.",
  "Medical College of Ohio.",
  "Medical College of Georgia.",
  "Medical University of South Carolina.",
  "Melbourne College of Divinity (Australia).",
  "Memorial University of Newfoundland (Canada).",
  "Miami Institute of Psychology of the Caribbean Center for Advanced Studies.",
  "Michigan School of Professional Psychology.",
  "Momoyama Gakuin University (Japan).",
  "Monash University (Australia).",
  "Multimedia University (Malaysia).",
  "Nagoya University (Japan).",
  "New England Conservatory of Music.",
  "New York Medical College.",
  "New York University, Graduate School of Business Administration.",
  "Ochanomizu University (Japan).",
  "Ontario College of Art & Design (Canada).",
  "Pacific Graduate School of Psychology.",
  "Palmer Graduate Library School.",
  "Parsons School of Design (The New School for Social Research).",
  "Peabody College for Teachers of Vanderbilt University.",
  "Pontificia Universita Gregoriana (Vatican City).",
  "Pontificia Universita S. Tommaso d'Aquino (Vatican City).",
  "Presbyterian School of Christian Education.",
  "Queensland University of Technology (Australia).",
  "Rikkyo University (Japan).",
  "Ruprecht-Karls-Universitaet Heidelberg (Germany).",
  "Russian Academy of Sciences (Russia).",
  "Rush University, College of Nursing.",
  "Rutgers The State University of New Jersey - New Brunswick and University of Medicine and Dentistry of New Jersey.",
  "Rutgers The State University of New Jersey, Graduate School of Applied and Professional Psychology.",
  "Semmelweis Egyetem (Hungary).",
  "Senshu Daigaku (Japan).",
  "Seton Hall University, College of Education and Human Services.",
  "Seton Hall University, School of Education.",
  "Showa Joshi Daigaku (Japan).",
  "Simmons College School of Social Work.",
  "Sotheby's Institute of Art - New York.",
  "State University of New York College of Environmental Science and Forestry.",
  "Sveuciliste u Zagrebu (Croatia).",
  "Tel Aviv University (Israel).",
  "The Australian National University (Australia).",
  "The Bard Graduate Center for Studies in the Decorative Arts, Design, and Culture.",
  "The Chicago School of Professional Psychology.",
  "The Chinese University of Hong Kong (Hong Kong).",
  "The Cooper Union for the Advancement of Science and Art.",
  "The Hebrew University of Jerusalem (Israel).",
  "The Herman M. Finch University of Health Sciences - The Chicago Medical School.",
  "The Institute for the Psychological Sciences.",
  "The Milltown Institute (Ireland).",
  "The University of Auckland (New Zealand).",
  "The University of Adelaide (Australia).",
  "The University of Buckingham (United Kingdom).",
  "The University of Edinburgh (United Kingdom).",
  "The University of Liverpool (United Kingdom).",
  "The University of Mississippi Medical Center.",
  "The University of New England (Australia).",
  "The University of Queensland (Australia).",
  "The University of Texas Medical Branch Graduate School of Biomedical Sciences.",
  "The University of Texas School of Public Health.",
  "The University of Vermont and State Agricultural College.",
  "The University of York (United Kingdom).",
  "The Victoria University of Manchester (United Kingdom).",
  "Tokyo Keizai University (Japan).",
  "Trinity College Dublin (University of Dublin) (Ireland).",
  "Trinity College and Seminary in Cooperation with the University of Liverpool (United Kingdom).",
  "Tulane University, School of Social Work.",
  "UMI.",
  "Union Theological Seminary & Presbyterian School of Christian Education.",
  "United States Sports Academy.",
  "Universidad Autonoma de Madrid (Spain).",
  "Universidad Complutense de Madrid (Spain).",
  "Universidad Internacional de La Rioja (Spain).",
  "Universidad Nacional Autonoma de Mexico (Mexico).",
  "Universidad Nacional de Educacion a Distancia (Spain).",
  "Universidad Politecnica de Madrid (Spain).",
  "Universidad Politecnica de Valencia (Spain).",
  "Universidad Pontificia Comillas de Madrid (Spain).",
  "Universidad Publica de Navarra (Spain).",
  "Universidad Simon Bolivar (Venezuela).",
  "Universidad de Cadiz (Spain).",
  "Universidad de Castilla - La Mancha (Spain).",
  "Universidad de Costa Rica (Costa Rica).",
  "Universidad de Deusto (Spain).",
  "Universidad de Granada (Spain).",
  "Universidad de Huelva (Spain).",
  "Universidad de Las Palmas de Gran Canaria (Spain).",
  "Universidad de Navarra (Spain).",
  "Universidad de Salamanca (Spain).",
  "Universidad de Valladolid (Spain).",
  "Universidad de Zaragoza (Spain).",
  "Universidad de la Rioja (Spain).",
  "Universidade de Sao Paulo (Brazil).",
  "Universita degli Studi di Milano (Italy).",
  "Universita degli Studi di Roma 'La Sapienza' (Italy).",
  "Universitaet Basel (Switzerland).",
  "Universitaet Bern (Switzerland).",
  "Universitaet Breslau (Germany).",
  "Universitaet fuer Musik und darstellende Kunst Wien (Austria).",
  "Universitaet zu Koeln (Germany).",
  "Universitaire Instelling Antwerpen (Belgium).",
  "Universitat de Valencia (Spain).",
  "Universite Catholique de Louvain (Belgium).",
  "Universite de Fribourg (Switzerland).",
  "Universite de Geneve (Switzerland).",
  "Universite de Paris III (Sorbonne-Nouvelle) (France).",
  "Universite de Paris VII (Denis Diderot) (France).",
  "Universite de Provence (Aix-Marseille I) (France).",
  "Universiteit Antwerpen (Belgium).",
  "Universiteit van Amsterdam (The Netherlands).",
  "Universitetet i Trondheim Norges Tekniske Hogskole (Norway).",
  "University College Dublin (Ireland).",
  "University of Aberdeen (United Kingdom).",
  "University of Birmingham (United Kingdom).",
  "University of Bristol (United Kingdom).",
  "University of California, Los Angeles School of Law.",
  "University of Cambridge (United Kingdom).",
  "University of Colorado Health Sciences Center.",
  "University of Delhi (India).",
  "University of Florida College of Nursing.",
  "University of Glasgow (United Kingdom).",
  "University of Hong Kong (Hong Kong).",
  "University of Illinois at Chicago, Health Sciences Center.",
  "University of Kent, Brussels School of International Studies (Belgium).",
  "University of Leeds (United Kingdom).",
  "University of London (United Kingdom).",
  "University of London, King's College (United Kingdom).",
  "University of London, University College London (United Kingdom).",
  "University of Melbourne (Australia).",
  "University of Michigan, Law School.",
  "University of Newcastle (Australia).",
  "University of North Texas Health Science Center at Fort Worth.",
  "University of Oxford (United Kingdom).",
  "University of Phoenix.",
  "University of Puerto Rico, Mayaguez (Puerto Rico).",
  "University of Puerto Rico, Rio Piedras (Puerto Rico).",
  "University of Santo Tomas (The Philippines).",
  "University of South Africa (South Africa).",
  "University of St. Andrews (United Kingdom).",
  "University of Sydney (Australia).",
  "University of Wales, Lampeter (United Kingdom).",
  "University of Warwick (United Kingdom).",
  "University of Western Australia (Australia).",
  "Univerzita Karlova (Czech Republic).",
  "Waseda University (Japan).",
  "Widener University School of Nursing.",
  "Widener University, Institute for Graduate Clinical Psychology.",
  "Wilmington College Division of Nursing (Delaware).",
  "Wisconsin School of Professional Psychology, Inc..",
  "Yale University, School of Forestry and Environmental Studies.",
  "Georgia State University - College of Education.",
  "California School of Professional Psychology - Berkeley/Alameda.",
  "University of Nebraska Medical Center.",
  "Oxford Centre for Mission Studies (United Kingdom).",
  "University of Stirling (United Kingdom).",
  "University of Rochester School of Nursing.",
  "The University of Manchester (United Kingdom).",
  "Annenberg Research Institute.",
  "The RAND Graduate School.",
  "Saybrook Graduate School and Research Center.",
  "The Union for Experimenting Colleges and Universities." 
)

# Remove any dissertation from one of the universities above
raw <- raw %.%
  filter(!(university %in% universities_to_delete))

# Standardize some school names
raw$university[str_detect(raw$university, "Fuller Theological Seminary")] <- "Fuller Theological Seminary."
raw$university[str_detect(raw$university, "Adelphi University")] <- "Adelphi University."

# Limit the data frame to only historical subjects
historical_subjects <- c("Art History.",
                         "Biography.",
                         "Economics, History.",
                         "History of Science.",
                         "History, African.",
                         "History, Ancient.",
                         "History, Asia, Australia and Oceania.",
                         "History, Black.",
                         "History, Canadian.",
                         "History, Church.",
                         "History, European.",
                         "History, General.",
                         "History, History of Oceania.",
                         "History, Latin American.",
                         "History, Medieval.",
                         "History, Middle Eastern.",
                         "History, Military.",
                         "History, Modern.",
                         "History, Russian and Soviet.",
                         "History, United States.",
                         "History, World History.",
                         "Religion, History of.")

# It appears that for dissertations after about 1985, ProQuest started giving 
# the subject1 heading to the topic of the dissertation, say religion or 
# physics, and started giving the methodology (some kind of history) to subject 
# 2. So there is a big gap in the data in the 1990s if you filter it only by 
# subject 1. I'm filtering it by all subjects.
historical <- filter(raw, subject1 %in% historical_subjects |
                          subject2 %in% historical_subjects |
                          subject3 %in% historical_subjects |
                          subject4 %in% historical_subjects)

# Throw away a few data points that have bad years.
historical <- filter(historical, year > 1800)

# Having limited the data frame to historical work, let's limit it to PhDs 
h_diss2 <- filter(historical, degree == "Ph.D.")

# Create a table of the number of dissertations by university
university_count <- h_diss2 %.%
  group_by(university) %.%
  summarise(count = n(),
            earliest_year = min(year),
            latest_year = max(year)) %.%
  arrange(desc(count))

# Remove dissertations from universities that have produced fewer than 5 disses
university_count <- university_count %.% filter(count >= 5)
more_unis_to_cut <- university_count %.% filter(count < 5)
more_unis_to_cut <- more_unis_to_cut$university

h_diss2 <- h_diss2 %.%
  filter(!(university %in% more_unis_to_cut))

# Make a smaller version for the web
unis_to_keep <- university_count$university[1:146]
h_diss2_web <- h_diss2 %.%
  select(pages, university, year) %.%
  filter(1950 <= year, year <= 2012)  %.%
  filter(university %in% unis_to_keep)

write.csv(h_diss2, "data/h_diss2.csv", row.names = FALSE)
write.csv(h_diss2_web, "pages-d3/h_diss2_web.csv", row.names = FALSE)
write.csv(university_count, "data/university_count.csv", row.names = FALSE)

# Clean up unneeded objects
rm(historical_subjects, universities_to_delete, raw, historical,
   more_unis_to_cut, h_diss2_web, unis_to_keep)

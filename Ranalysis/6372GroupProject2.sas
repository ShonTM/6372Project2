/* Generated Code (IMPORT) */
/* Source File: trainDataClean.csv */
/* Source Path: /home/dserna0/Code/6372/GroupProject2 */
/* Code generated on: 12/1/18, 2:39 PM */

%web_drop_table(trainData);


FILENAME REFFILE '/home/dserna0/Code/6372/GroupProject2/factorizeddata.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=trainData;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=trainData; RUN;


%web_open_table(trainData);

%web_drop_table(trainDataClean);


FILENAME REFFILE '/home/dserna0/Code/6372/GroupProject2/trainDataClean.csv';

PROC IMPORT DATAFILE=REFFILE
	DBMS=CSV
	OUT=trainDataClean;
	GETNAMES=YES;
RUN;

PROC CONTENTS DATA=trainDataClean; RUN;


%web_open_table(trainDataClean);

/* data type conversions */
data trainData;
set trainData;
intSeason = input(season, BEST32.);
drop season;
rename intSeason = season;

data trainDataClean;
set trainDataClean;
intSeason = input(season, BEST32.);
drop season;
rename intSeason = season;
run;

/* transformations */
data trainDataClean;
set trainDataClean;
log_shot_distance = log(shot_distance);
log_lat = log(lat);
log_loc_y = log(log_loc_y);
run;

data trainData;
set trainData;
log_shot_distance = log(shot_distance);
log_lat = log(lat);
log_loc_y = log(loc_y);
run;


/*categorical variable conversions*/
/*
data trainData;
set trainData;
if shot_type = "2PT Field Goal" then shot_type_int = 1;
if shot_type = "3PT Field Goal" then shot_type_int = 2;
if opponent = "ATL" then opponent_int = 1;
if opponent = "BNK" then opponent_int = 2;
if opponent = "BOS" then opponent_int = 3;
if opponent = "CHA" then opponent_int = 4;
if opponent = "CHI" then opponent_int = 5;
if opponent = "CLE" then opponent_int = 6;
if opponent = "DAL" then opponent_int = 7;
if opponent = "DEN" then opponent_int = 8;
if opponent = "DET" then opponent_int = 9;
if opponent = "GSW" then opponent_int = 10;
if opponent = "HOU" then opponent_int = 11;
if opponent = "IND" then opponent_int = 12;
if opponent = "LAC" then opponent_int = 13;
if opponent = "MEM" then opponent_int = 14;
if opponent = "MIA" then opponent_int = 15;
if opponent = "MIL" then opponent_int = 16;
if opponent = "NIN" then opponent_int = 17;
if opponent = "NJN" then opponent_int = 18;
if opponent = "NOH" then opponent_int = 19;
if opponent = "NOP" then opponent_int = 20;
if opponent = "NYK" then opponent_int = 21;
if opponent = "OKC" then opponent_int = 22;
if opponent = "ORL" then opponent_int = 23;
if opponent = "PHI" then opponent_int = 24;
if opponent = "PHX" then opponent_int = 25;
if opponent = "POR" then opponent_int = 26;
if opponent = "SAC" then opponent_int = 27;
if opponent = "SAS" then opponent_int = 28;
if opponent = "SEA" then opponent_int = 29;
if opponent = "TOR" then opponent_int = 30;
if opponent = "UTA" then opponent_int = 31;
if opponent = "VAN" then opponent_int = 32;
if opponent = "WAS" then opponent_int = 33;

data trainDataClean;
set trainDataClean;
if shot_type = "2PT Field Goal" then shot_type_int = 1;
if shot_type = "3PT Field Goal" then shot_type_int = 2;
if opponent = "ATL" then opponent_int = 1;
if opponent = "BNK" then opponent_int = 2;
if opponent = "BOS" then opponent_int = 3;
if opponent = "CHA" then opponent_int = 4;
if opponent = "CHI" then opponent_int = 5;
if opponent = "CLE" then opponent_int = 6;
if opponent = "DAL" then opponent_int = 7;
if opponent = "DEN" then opponent_int = 8;
if opponent = "DET" then opponent_int = 9;
if opponent = "GSW" then opponent_int = 10;
if opponent = "HOU" then opponent_int = 11;
if opponent = "IND" then opponent_int = 12;
if opponent = "LAC" then opponent_int = 13;
if opponent = "MEM" then opponent_int = 14;
if opponent = "MIA" then opponent_int = 15;
if opponent = "MIL" then opponent_int = 16;
if opponent = "NIN" then opponent_int = 17;
if opponent = "NJN" then opponent_int = 18;
if opponent = "NOH" then opponent_int = 19;
if opponent = "NOP" then opponent_int = 20;
if opponent = "NYK" then opponent_int = 21;
if opponent = "OKC" then opponent_int = 22;
if opponent = "ORL" then opponent_int = 23;
if opponent = "PHI" then opponent_int = 24;
if opponent = "PHX" then opponent_int = 25;
if opponent = "POR" then opponent_int = 26;
if opponent = "SAC" then opponent_int = 27;
if opponent = "SAS" then opponent_int = 28;
if opponent = "SEA" then opponent_int = 29;
if opponent = "TOR" then opponent_int = 30;
if opponent = "UTA" then opponent_int = 31;
if opponent = "VAN" then opponent_int = 32;
if opponent = "WAS" then opponent_int = 33;
run;
*/

data trainDataClean;
set trainDataClean;
Obs = _n_;
run;

data trainData;
set trainData;
Obs = _n_;
run;


/* Proposition 1 - Odds Ratio */
proc logistic data = trainData descending;
model shot_made_flag(event="1") = shot_distance / selection=stepwise ctable pprob = 0.5;
output out=logisticOut predprobs = I p=predprob resdev=resdev reschi=pearres;
run;

/* Proposition 3 - odds differnet in playoffs */
data trainDataNonPlayoffs;
set trainData;
if playoffs EQ 1 then delete;
run;

data trainDataPlayoffs;
set trainData;
if playoffs EQ 0 then delete;
run;

/*
proc print data = trainDataNonPlayoffs(OBS=50);run;
proc print data = trainDataPlayoffs(OBS=50);run;
*/

proc logistic data = trainDataNonPlayoffs descending;
model shot_made_flag(event="1") = shot_distance / selection=stepwise ctable pprob = 0.5;
output out=logisticOut predprobs = I p=predprob resdev=resdev reschi=pearres;
run;

proc logistic data = trainDataPlayoffs descending;
model shot_made_flag(event="1") = shot_distance / selection=stepwise ctable pprob = 0.5;
output out=logisticOut predprobs = I p=predprob resdev=resdev reschi=pearres;
run;


/* Predictive Models - Logistic Regression  */
proc logistic data = trainData descending;
model shot_made_flag(event="1") = action_type_int shot_type_int shot_zone_range_int opponent_int log_lat log_loc_y lon minutes_remaining playoffs season seconds_remaining log_shot_distance arena_temp / selection=stepwise ctable pprob = 0.5;
output out=logisticOut predprobs = I p=predprob resdev=resdev reschi=pearres;
run;

/* Predictive Models - Linear Discriminant Analysis */
data ldaInput;
set trainData;
if mod(obs, 2) EQ 0 then delete;
run;

data ldaToCategorize;
set trainData;
if mod(obs, 2) NE 0 then delete;
run;

proc discrim data=ldaInput pool=YES crossvalidate testdata=ldatocategorize testout=discrimOut;
class shot_made_flag;
var action_type_int shot_type_int shot_zone_range_int opponent_int log_lat log_loc_y lon minutes_remaining playoffs season seconds_remaining log_shot_distance arena_temp;
priors "1" = 0.5 "0" = 0.5;
run;

data discrimOut;
set discrimOut;
rename '1'n = shot_made_probability;
rename '0'n = shot_not_made_probability;
run;

/* Proposition 2 - probability shot_made decreases with distance */
proc reg data=discrimOut;
model shot_distance = shot_made_probability;
run;
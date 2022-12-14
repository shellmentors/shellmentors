#OPTION('obfuscateOutput', TRUE);

IMPORT STD;
IMPORT $.InputRecords;

_Distance         := 0  : STORED('Distance', FORMAT(SEQUENCE(1)));
_FirstName        := '' : STORED('FirstName', FORMAT(SEQUENCE(2)));
_LastName         := '' : STORED('LastName', FORMAT(SEQUENCE(3)));
_ZipCode          := '' : STORED('ZipCode', FORMAT(SEQUENCE(7)));
_Birthday         := '' : STORED('Birthday', FORMAT(SEQUENCE(9)));
_Race_Ethnicity   := '' : STORED('Race_Ethnicity', FORMAT(
                          SELECT('Black/African American=Black/African American,White=White, Hispanic/Latino (non_white)=Hispanic/Latino (non_white),*')));


Youth := InputRecords.Youth_TestData(FirstName=_FirstName,
                                    LastName=_LastName,
                                    ZipCode=_ZipCode,
                                    Birthday=_Birthday,
                                    Race_Ethnicity=_Race_Ethnicity);

OUTPUT(Youth, NAMED('YouthRecord'));



REAL Haversine (REAL4 LAT1, REAL4 LON1, REAL LAT2, REAL4 LON2) := FUNCTION

    REAL Rad2Deg := 57.295779513082;
    REAL Deg2Rad := 0.0174532925199;

    REAL deltaPhi := ABS(LAT2 - LAT1) * Deg2Rad * 0.5;
    REAL deltaLambda := ABS(LON2 - LON1) * Deg2Rad * 0.5;

    REAL sinPhi := POWER(SIN(deltaPhi), 2);
    REAL sinLambda := POWER(SIN(deltaLambda), 2);

    REAL cosPhi1 := COS(LAT1);
    REAL cosPhi2 := COS(LAT2);

    REAL A := sinPhi + cosPhi1 * cosPhi2 * sinLambda;

    REAL C := 2 * ATAN2(SQRT(A), SQRT(1-A));

    RETURN 3958.8 * C;

END;


MentorsPreMatchLayout := RECORD
    STRING       FullName;
    STRING       FirstName;
    STRING       LastName;
    STRING       Gender;
    STRING       Status;
    STRING       Region;
    STRING       Ethnicity;
    STRING       Occupation_primary;
    STRING       MaritalStatus;
    STRING       Spouse_FirstName;
    STRING       Spouse_LastName;
    STRING       Spouse_Gender;
    STRING       Spouse_RaceEthnicity;
    STRING       Spouse_Birthday;
    STRING       Spouse_Age;
    STRING       Spouse_Occupation;
    STRING       Street;
    STRING       City;
    STRING       State;
    STRING       ZipCode;
    INTEGER1     Religion_Christian;
    INTEGER1     Religion_Muslim;
    INTEGER1     Religion_Jewish;
    INTEGER1     Religion_Hindu;
    INTEGER1     Religion_Buddhist;
    INTEGER1     Religion_Other;
    INTEGER1     Religion_Spiritual;
    INTEGER1     Religion_None;
    STRING       RoleofFaith_primary;
    STRING       RoleofFaith_spouse;
    INTEGER1     Alcohol_Occasional;
    INTEGER1     Alcohol_Responsible;
    INTEGER1     Alcohol_Irresponsible;
    INTEGER1     DrugUse;
    INTEGER1     Marijuana_Occasional;
    INTEGER1     Marijuana_Regular;
    INTEGER1     Cigarettes_Occasional;
    INTEGER1     Cigarettes_Regular;
    INTEGER1     Vaping_Occasional;
    INTEGER1     Vaping_Regular;
    INTEGER1     JobRetentionChallenges;
    STRING       DayOff_primary;
    STRING       DayOff_spouse;
    STRING       FavoritPlace_primary;
    STRING       FavoritePlace_spouse;
    STRING       Personality_primary;
    STRING       Personality_spouse;
    INTEGER1     SocialStyle_Introverted;
    INTEGER1     SocialStyle_Extraverted;
    INTEGER1     SocialStyle_Both;
    STRING       SadnessResponse_primary;
    STRING       SadnessResponse_spouse;
    STRING       AngerResponse_primary;
    STRING       AngerResponse_spouse;
    INTEGER1     ContinuingEducation;
    INTEGER1     Supports_Holidays;
    INTEGER1     Supports_Job;
    INTEGER1     Supports_Parenting;
    INTEGER1     Supports_Medical;
    INTEGER1     Supports_Legal;
    INTEGER1     Supports_Budgeting;
    INTEGER1     Supports_MentalHealth;
    INTEGER1     Supports_Resources;
    INTEGER1     Supports_Social;
    STRING       Multiple_Matches;
    STRING       Match_Housing;
    STRING       Emergency_Housing;
    INTEGER1     CriminalHistory_Arrested;
    INTEGER1     CriminalHistory_Jail;
    INTEGER1     CriminalHistory_CurrentProbation;
    INTEGER1     Children_Pregnant;
    INTEGER1     Children_Custody1;
    INTEGER1     Children_Custodymultiple;
    INTEGER1     Children_Kincare1;
    INTEGER1     Children_Kincaremultiple;
    INTEGER1     Children_Welfare1;
    INTEGER1     Children_Welfaremultiple;
    INTEGER1     Bio_Important;
    INTEGER1     Bio_Difficult;
    INTEGER1     Sexuality_Heterosexual;
    INTEGER1     Sexuality_Homosexual;
    INTEGER1     Sexuality_Bisexual;
    INTEGER1     Gender_Male;
    INTEGER1     Gender_Female;
    INTEGER1     Gender_Transgender;
    INTEGER1     Gender_Non_binary;
    REAL4        Latitude;
    REAL4        Logatitude;
    REAL         Distance;
    REAL         MaximumDistance;
    STRING    Religion;
    STRING    RoleofFaith;
    STRING    AlcoholUse;
    STRING    Smoking;
    STRING    JobRetentionChallengesStr;
    STRING    DayOff;
    STRING    FavoritePlace;
    STRING    Personality;
    STRING    SocialStyle;
    STRING    SadnessResponse;
    STRING    AngerResponse;
    STRING    ContinuingEducationStr; 
    STRING    SupportNeeds;
    STRING    LivingSituation;
    STRING    CriminalHistory;
    STRING    Children;
    STRING    BioRelationships;
    STRING    Sexuality;
    STRING    GenderIdentity;
    STRING    Sex;
END;




MentorsPreMatchDS := JOIN(
    InputRecords.MentorsRaw_DS,
    Youth,
    TRUE,
    TRANSFORM(
        MentorsPreMatchLayout,
        SELF := LEFT;
        SELF.Religion := RIGHT.Religion;
        SELF.RoleofFaith := RIGHT.RoleofFaith;
        SELF.AlcoholUse := RIGHT.AlcoholUse;
        SELF.Smoking := RIGHT.Smoking;
        SELF.JobRetentionChallengesStr := RIGHT.JobRetentionChallenges;
        SELF.DayOff := RIGHT.DayOff;
        SELF.FavoritePlace := RIGHT.FavoritePlace;
        SELF.Personality := RIGHT.Personality;
        SELF.SocialStyle := RIGHT.SocialStyle;
        SELF.SadnessResponse := RIGHT.SadnessResponse;
        SELF.AngerResponse := RIGHT.AngerResponse;
        SELF.ContinuingEducationStr := RIGHT.ContinuingEducation; 
        SELF.SupportNeeds := RIGHT.SupportNeeds;
        SELF.LivingSituation := RIGHT.LivingSituation;
        SELF.CriminalHistory := RIGHT.CriminalHistory;
        SELF.Children := RIGHT.Children;
        SELF.BioRelationships := RIGHT.BioRelationships;
        SELF.Sexuality := RIGHT.Sexuality;
        SELF.GenderIdentity := RIGHT.Gender;
        SELF.Sex := RIGHT.BiologicalGender;
        SELF.MaximumDistance := _Distance;
        SELF.Distance := Haversine(Left.Latitude, Left.Logatitude,  Right.Latitude, Right.Logatitude);
    ),
    ALL
);

MentorsMatchedDS := MentorsPreMatchDS(
    IF(MaximumDistance >= Distance AND Distance >= 0, TRUE, FALSE) AND
    // religion
    IF(Religion = 'Christianity', Religion_Christian > 0, TRUE) AND
    IF(Religion = 'Islam', Religion_Muslim > 0, TRUE) AND
    IF(Religion = 'Judaism', Religion_Jewish > 0, TRUE) AND
    IF(Religion = 'Hinduism', Religion_Hindu > 0, TRUE) AND
    IF(Religion = 'Buddhism', Religion_Buddhist > 0, TRUE) AND
    IF(Religion = 'Other', Religion_Other > 0, TRUE) AND
    IF(Religion = 'Spiritual', Religion_Spiritual > 0, TRUE) AND
    IF(Religion = 'None', Religion_None > 0, TRUE) AND
    
    // drug usage
    IF(AlcoholUse = 'Occasionally', Alcohol_Occasional > 0, TRUE) AND
    IF(AlcoholUse = 'Responsibly', Alcohol_Responsible > 0, TRUE) AND
    IF(AlcoholUse = 'Irresponsibly', Alcohol_Irresponsible > 0, TRUE) AND
    IF(STD.Str.Find(Smoking, 'Occasional marijuana') != 0, Marijuana_Occasional > 0, True) AND
    IF(STD.Str.Find(Smoking, 'Regular marijuana') != 0, Marijuana_Regular > 0, True) AND
    IF(STD.Str.Find(Smoking, 'Occasional cigarettes') != 0, Cigarettes_Occasional > 0, True) AND
    IF(STD.Str.Find(Smoking, 'Regular cigarettes') != 0, Cigarettes_Regular > 0, True) AND
    IF(STD.Str.Find(Smoking, 'Occasional vape') != 0, Vaping_Occasional > 0, True) AND
    IF(STD.Str.Find(Smoking, 'Regular vape') != 0, Vaping_Regular > 0, True) AND  
    
    // job retention  
    IF(JobRetentionChallengesStr = 'Checked', JobRetentionChallenges > 0, TRUE) AND
    
    // social style
    IF(SocialStyle = 'Introverted', SocialStyle_Introverted > 0, TRUE) AND
    IF(SocialStyle = 'Extroverted', SocialStyle_Extraverted > 0, TRUE) AND
    IF(SocialStyle = 'BOTH', SocialStyle_Introverted > 0, TRUE) AND
    IF(SocialStyle = 'BOTH', SocialStyle_Extraverted > 0, TRUE) AND

    // ContinuingEducation
    IF(STD.Str.Find(ContinuingEducationStr, 'checked') != 0, ContinuingEducation > 0, TRUE) AND

    // SupportNeeds
    IF(STD.Str.Find(SupportNeeds, 'Holidays') != 0, Supports_Holidays > 0, TRUE) AND
    IF(STD.Str.Find(SupportNeeds, 'Job') != 0, Supports_Job > 0, TRUE) AND
    IF(STD.Str.Find(SupportNeeds, 'Parenting') != 0, Supports_Parenting > 0, TRUE) AND
    IF(STD.Str.Find(SupportNeeds, 'Medical') != 0, Supports_Medical > 0, TRUE) AND
    IF(STD.Str.Find(SupportNeeds, 'Pregnant') != 0, Supports_Legal > 0, TRUE) AND
    IF(STD.Str.Find(SupportNeeds, 'Budgeting') != 0, Supports_Budgeting > 0, TRUE) AND
    IF(STD.Str.Find(SupportNeeds, 'Mental Health') != 0, Supports_MentalHealth > 0, TRUE) AND
    IF(STD.Str.Find(SupportNeeds, 'Resources') != 0, Supports_Resources > 0, TRUE) AND
    IF(STD.Str.Find(SupportNeeds, 'Social') != 0, Supports_Social > 0, TRUE) AND    

    //criminal history 	
    IF(STD.Str.Find(CriminalHistory, 'Arrested') != 0, CriminalHistory_Arrested > 0, TRUE) AND
    IF(STD.Str.Find(CriminalHistory, 'Jail') != 0, CriminalHistory_Jail > 0, TRUE) AND
    IF(STD.Str.Find(CriminalHistory, '	Current Probation') != 0, CriminalHistory_CurrentProbation > 0, TRUE) AND

    //children
    IF(STD.Str.Find(Children, 'Pregnant') != 0, Children_Pregnant > 0, TRUE) AND
    IF(STD.Str.Find(Children, 'Caring for 1') != 0, Children_Custody1 > 0, TRUE) AND
    IF(STD.Str.Find(Children, 'Caring for multiple') != 0, Children_Custodymultiple > 0, TRUE) AND
    IF(STD.Str.Find(Children, '1 in kincare') != 0, Children_Kincare1 > 0, TRUE) AND
    IF(STD.Str.Find(Children, 'Pregnant') != 0, Children_Kincaremultiple > 0, TRUE) AND
    IF(STD.Str.Find(Children, '1 in welfare') != 0, Children_Welfare1 > 0, TRUE) AND
    IF(STD.Str.Find(Children, 'Multiple in welfare') != 0, Children_Welfaremultiple > 0, TRUE) AND

    //bio relationships
    IF(BioRelationships = 'Difficult', Bio_Difficult > 0, TRUE) AND
    IF(BioRelationships = 'Important', Bio_Important > 0, TRUE) AND

    //sexuality
    IF(Sexuality = 'Heterosexual', Sexuality_Heterosexual > 0, TRUE) AND
    IF(Sexuality = 'Homosexual', Sexuality_Homosexual > 0, TRUE) AND
    IF(Sexuality = 'Bisexual', Sexuality_Bisexual > 0, TRUE) AND         
    
    //gender
    IF(Sex = 'Other', Gender_Non_binary > 0, TRUE) AND
    IF(Sex = 'Other', Gender_Transgender > 0, TRUE) AND 
    IF(GenderIdentity = 'Female' AND Sex = 'Male', Gender_Transgender > 0, TRUE) AND
    IF(GenderIdentity = 'Male' AND Sex = 'Female', Gender_Transgender > 0, TRUE) AND
    IF(GenderIdentity = 'Male', Gender_Male > 0, TRUE) AND
    IF(GenderIdentity = 'Female', Gender_Female > 0, TRUE)
);


MentorsPostMatchLayout := RECORD
    STRING       FullName;
    STRING       FirstName;
    STRING       LastName;
    STRING       Gender;
    STRING       Status;
    STRING       Region;
    STRING       Ethnicity;
    STRING       Occupation_primary;
    STRING       MaritalStatus;
    STRING       Spouse_FirstName;
    STRING       Spouse_LastName;
    STRING       Spouse_Gender;
    STRING       Spouse_RaceEthnicity;
    STRING       Spouse_Birthday;
    STRING       Spouse_Age;
    STRING       Spouse_Occupation;
    STRING       Street;
    STRING       City;
    STRING       State;
    STRING       ZipCode;
    INTEGER1     Religion_Christian;
    INTEGER1     Religion_Muslim;
    INTEGER1     Religion_Jewish;
    INTEGER1     Religion_Hindu;
    INTEGER1     Religion_Buddhist;
    INTEGER1     Religion_Other;
    INTEGER1     Religion_Spiritual;
    INTEGER1     Religion_None;

    // postmatch
    DECIMAL2_1       RoleofFaithAverage;


    INTEGER1     Alcohol_Occasional;
    INTEGER1     Alcohol_Responsible;
    INTEGER1     Alcohol_Irresponsible;
    INTEGER1     DrugUse;
    INTEGER1     Marijuana_Occasional;
    INTEGER1     Marijuana_Regular;
    INTEGER1     Cigarettes_Occasional;
    INTEGER1     Cigarettes_Regular;
    INTEGER1     Vaping_Occasional;
    INTEGER1     Vaping_Regular;
    INTEGER1     JobRetentionChallenges;

    // postmatch    
    DECIMAL2_1       DayOffAverage;
    DECIMAL2_1       FavoritePlaceAverage;
    DECIMAL2_1       PersonalityAverage;


    INTEGER1     SocialStyle_Introverted;
    INTEGER1     SocialStyle_Extraverted;
    INTEGER1     SocialStyle_Both;

    // postmatch
    DECIMAL2_1       SadnessResponseAverage;
    DECIMAL2_1       AngerResponseAverage;


    INTEGER1     ContinuingEducation;
    INTEGER1     Supports_Holidays;
    INTEGER1     Supports_Job;
    INTEGER1     Supports_Parenting;
    INTEGER1     Supports_Medical;
    INTEGER1     Supports_Legal;
    INTEGER1     Supports_Budgeting;
    INTEGER1     Supports_MentalHealth;
    INTEGER1     Supports_Resources;
    INTEGER1     Supports_Social;
    STRING       Multiple_Matches;
    STRING       Match_Housing;
    STRING       Emergency_Housing;
    INTEGER1     CriminalHistory_Arrested;
    INTEGER1     CriminalHistory_Jail;
    INTEGER1     CriminalHistory_CurrentProbation;
    INTEGER1     Children_Pregnant;
    INTEGER1     Children_Custody1;
    INTEGER1     Children_Custodymultiple;
    INTEGER1     Children_Kincare1;
    INTEGER1     Children_Kincaremultiple;
    INTEGER1     Children_Welfare1;
    INTEGER1     Children_Welfaremultiple;
    INTEGER1     Bio_Important;
    INTEGER1     Bio_Difficult;
    INTEGER1     Sexuality_Heterosexual;
    INTEGER1     Sexuality_Homosexual;
    INTEGER1     Sexuality_Bisexual;
    INTEGER1     Gender_Male;
    INTEGER1     Gender_Female;
    INTEGER1     Gender_Transgender;
    INTEGER1     Gender_Non_binary;
    REAL4        Latitude;
    REAL4        Logatitude;
    REAL         Distance;    
    STRING    Religion;
    STRING    RoleofFaith;
    STRING    AlcoholUse;
    STRING    Smoking;
    STRING    JobRetentionChallengesStr;
    STRING    DayOff;
    STRING    FavoritePlace;
    STRING    Personality;
    STRING    SocialStyle;
    STRING    SadnessResponse;
    STRING    AngerResponse;
    STRING    ContinuingEducationStr; 
    STRING    SupportNeeds;
    STRING    LivingSituation;
    STRING    CriminalHistory;
    STRING    Children;
    STRING    BioRelationships;
    STRING    Sexuality;
    STRING    GenderIdentity;
    STRING    Sex;
END;


MentorsPostMatchLayout PostMatch (MentorsPreMatchLayout L) := TRANSFORM
    SELF.RoleofFaithAverage := (IF(L.RoleofFaith = L.RoleofFaith_primary, 1, 0) + IF(L.RoleofFaith = L.RoleofFaith_spouse, 1, 0)) / IF(L.Spouse_FirstName = '', 1, 2);
    SELF.DayOffAverage := (IF(L.DayOff = L.DayOff_primary, 1, 0) + IF(L.DayOff = L.DayOff_spouse, 1, 0)) / IF(L.Spouse_FirstName = '', 1, 2);
    SELF.FavoritePlaceAverage := (IF(L.FavoritePlace = L.FavoritPlace_primary, 1, 0) + IF(L.FavoritePlace = L.FavoritePlace_spouse, 1, 0)) / IF(L.Spouse_FirstName = '', 1, 2);    
    SELF.PersonalityAverage := (IF(L.Personality = L.Personality_primary, 1, 0) + IF(L.Personality = L.Personality_spouse, 1, 0)) / IF(L.Spouse_FirstName = '', 1, 2);  
    SELF.SadnessResponseAverage := (IF(L.SadnessResponse = L.SadnessResponse_primary, 1, 0) + IF(L.SadnessResponse = L.SadnessResponse_spouse, 1, 0)) / IF(L.Spouse_FirstName = '', 1, 2);        
    SELF.AngerResponseAverage := (IF(L.AngerResponse = L.AngerResponse_primary, 1, 0) + IF(L.AngerResponse = L.AngerResponse_spouse, 1, 0)) / IF(L.Spouse_FirstName = '', 1, 2);    
    SELF := L;
END;


MentorsPostMatchDS := PROJECT(MentorsMatchedDS,
                              PostMatch(LEFT));


MentorsMatchedFinalLayout := RECORD
    STRING       FullName;
    STRING       FirstName;
    STRING       LastName;
    STRING       Gender;
    STRING       Status;
    STRING       Region;
    STRING       Ethnicity;
    STRING       Occupation_primary;
    STRING       MaritalStatus;
    STRING       Spouse_FirstName;
    STRING       Spouse_LastName;
    STRING       Spouse_Gender;
    STRING       Spouse_RaceEthnicity;
    STRING       Spouse_Birthday;
    STRING       Spouse_Age;
    STRING       Spouse_Occupation;
    STRING       Street;
    STRING       City;
    STRING       State;
    STRING       ZipCode;
    INTEGER1     Religion_Christian;
    INTEGER1     Religion_Muslim;
    INTEGER1     Religion_Jewish;
    INTEGER1     Religion_Hindu;
    INTEGER1     Religion_Buddhist;
    INTEGER1     Religion_Other;
    INTEGER1     Religion_Spiritual;
    INTEGER1     Religion_None;

    // postmatch
    DECIMAL2_1       RoleofFaithAverage;


    INTEGER1     Alcohol_Occasional;
    INTEGER1     Alcohol_Responsible;
    INTEGER1     Alcohol_Irresponsible;
    INTEGER1     DrugUse;
    INTEGER1     Marijuana_Occasional;
    INTEGER1     Marijuana_Regular;
    INTEGER1     Cigarettes_Occasional;
    INTEGER1     Cigarettes_Regular;
    INTEGER1     Vaping_Occasional;
    INTEGER1     Vaping_Regular;
    INTEGER1     JobRetentionChallenges;

    // postmatch    
    DECIMAL2_1       DayOffAverage;
    DECIMAL2_1       FavoritePlaceAverage;
    DECIMAL2_1       PersonalityAverage;


    INTEGER1     SocialStyle_Introverted;
    INTEGER1     SocialStyle_Extraverted;
    INTEGER1     SocialStyle_Both;

    // postmatch
    DECIMAL2_1       SadnessResponseAverage;
    DECIMAL2_1       AngerResponseAverage;


    INTEGER1     ContinuingEducation;
    INTEGER1     Supports_Holidays;
    INTEGER1     Supports_Job;
    INTEGER1     Supports_Parenting;
    INTEGER1     Supports_Medical;
    INTEGER1     Supports_Legal;
    INTEGER1     Supports_Budgeting;
    INTEGER1     Supports_MentalHealth;
    INTEGER1     Supports_Resources;
    INTEGER1     Supports_Social;
    STRING       Multiple_Matches;
    STRING       Match_Housing;
    STRING       Emergency_Housing;
    INTEGER1     CriminalHistory_Arrested;
    INTEGER1     CriminalHistory_Jail;
    INTEGER1     CriminalHistory_CurrentProbation;
    INTEGER1     Children_Pregnant;
    INTEGER1     Children_Custody1;
    INTEGER1     Children_Custodymultiple;
    INTEGER1     Children_Kincare1;
    INTEGER1     Children_Kincaremultiple;
    INTEGER1     Children_Welfare1;
    INTEGER1     Children_Welfaremultiple;
    INTEGER1     Bio_Important;
    INTEGER1     Bio_Difficult;
    INTEGER1     Sexuality_Heterosexual;
    INTEGER1     Sexuality_Homosexual;
    INTEGER1     Sexuality_Bisexual;
    INTEGER1     Gender_Male;
    INTEGER1     Gender_Female;
    INTEGER1     Gender_Transgender;
    INTEGER1     Gender_Non_binary;
    REAL4        Latitude;
    REAL4        Logatitude;
    REAL         Distance;
    REAL         TotalScore;
END;

MentorsMatchedFinalLayout Finalize (MentorsPostMatchLayout L) := TRANSFORM
    SELF := L;
    SELF.TotalScore := (L.Religion_Christian + 
                   L.Religion_Muslim + 
                   L.Religion_Jewish + 
                   L.Religion_Hindu + 
                   L.Religion_Buddhist +
                   L.Religion_Other + 
                   L.Religion_Spiritual +
                   L.Religion_None +
                   L.RoleofFaithAverage +
                   L.Alcohol_Occasional + 
                   L.Alcohol_Responsible +
                   L.Alcohol_Irresponsible +
                   L.DrugUse + 
                   L.Marijuana_Occasional + 
                   L.Marijuana_Regular + 
                   L.Cigarettes_Occasional + 
                   L.Cigarettes_Regular + 
                   L.Vaping_Occasional + 
                   L.Vaping_Regular + 
                   L.JobRetentionChallenges + 
                   L.DayOffAverage + 
                   L.FavoritePlaceAverage + 
                   L.PersonalityAverage + 
                   L.SocialStyle_Introverted + 
                   L.SocialStyle_Extraverted + 
                   L.SocialStyle_Both + 
                   L.SadnessResponseAverage + 
                   L.AngerResponseAverage + 
                   L.ContinuingEducation + 
                   L.Supports_Holidays + 
                   L.Supports_Job + 
                   L.Supports_Parenting + 
                   L.Supports_Medical + 
                   L.Supports_Legal + 
                   L.Supports_Budgeting + 
                   L.Supports_MentalHealth + 
                   L.Supports_Resources + 
                   L.Supports_Social + 
                   L.CriminalHistory_Arrested + 
                   L.CriminalHistory_Jail + 
                   L.CriminalHistory_CurrentProbation + 
                   L.Children_Pregnant + 
                   L.Children_Custody1 + 
                   L.Children_Custodymultiple + 
                   L.Children_Kincare1 + 
                   L.Children_Kincaremultiple + 
                   L.Children_Welfare1 + 
                   L.Children_Welfaremultiple + 
                   L.Bio_Important + 
                   L.Bio_Difficult + 
                   L.Sexuality_Heterosexual + 
                   L.Sexuality_Homosexual + 
                   L.Sexuality_Bisexual + 
                   L.Gender_Male + 
                   L.Gender_Female + 
                   L.Gender_Transgender + 
                   L.Gender_Non_binary);
END;



MentorsMatchedFinal := PROJECT(MentorsPostMatchDS,
                               Finalize(LEFT));


MentorsMatchedFinalSorted := SORT(MentorsMatchedFinal, -TotalScore);


OUTPUT(MentorsMatchedFinalSorted, NAMED('MentorsMatchedFinalSorted'));

* Highest grade completed
gen hgc = high_grade_comp_May

gen grad4yr = hgc>=16 & ~mi(hgc)

bys id (wave): egen maxged = max(diploma_or_ged)
gen ged = inlist(maxged,2,3)

gen gradHS  = (hgc>=12 & ~mi(hgc)) | ged

replace gradHS  = . if !mi(reason_noninterview)
replace grad4yr = . if !mi(reason_noninterview)


generat commOrg        = HSclubCYO==1            if !inlist(HSclubCYO,.,.i,.n,.r)
generat hobbyClub      = HSclubHobby==2          if !inlist(HSclubHobby,.,.i,.n,.r)
generat studentCouncil = HSclubStudentCouncil==3 if !inlist(HSclubStudentCouncil,.,.i,.n,.r)
generat yrbookPaper    = HSclubYrbookPaper==4    if !inlist(HSclubYrbookPaper,.,.i,.n,.r)
generat athlete        = HSclubAthletics==5      if !inlist(HSclubAthletics,.,.i,.n,.r)
generat strongAthlete  = HSclubMostActive==5     if !inlist(HSclubMostActive,.,.i,.n,.r)
generat performArts    = HSclubPerfArts==6       if !inlist(HSclubPerfArts,.,.i,.n,.r)
generat nhs            = HSclubNHS==7            if !inlist(HSclubNHS,.,.i,.n,.r)
generat otherClub      = HSclubOther==8          if !inlist(HSclubOther,.,.i,.n,.r)
generat no_clubs       = HSclubNone==0           if !inlist(HSclubNone,.,.i,.n,.r)

lab var hgc            "Highest Grade Completed (years)"
lab var ged            "Holds a GED"
lab var gradHS         "Absorbing indicator for HS graduation (or GED)"
lab var grad4yr        "Absorbing indicator for 4-year college graduation"
lab var commOrg        "Participated in comm. youth organizations in high school"
lab var hobbyClub      "Participated in school-sponsored hobby clubs in high school"
lab var studentCouncil "Participated in student council in high school"
lab var yrbookPaper    "Participated in yearbook / newspaper in high school"
lab var athlete        "Participated in athletics in high school"
lab var strongAthlete  "Participated in athletics most actively in high school"
lab var performArts    "Participated in performing arts in high school"
lab var nhs            "Participated in National Honor Society in high school"
lab var otherClub      "Participated in some other club in high school"
lab var no_clubs       "Did not participate in any clubs in high school"

** Variables to keep:
global keeperschool hgc ged gradHS grad4yr commOrg hobbyClub studentCouncil yrbookPaper athlete strongAthlete performArts nhs otherClub no_clubs

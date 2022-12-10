/* 1) Display the name and the capacity of the AIRBUS planes.
( Plane's description that starts with A->AIRBUS, B->BOEING, 
C->CONCORDE). */
SELECT
	PLA_DESC,
	MAX_PASSENGER
FROM
	PLANE
WHERE
	PLA_DESC LIKE 'A%'


/* 2) Display the identifications of the pilots 
 who have more than two flights (>=) departures from Montreal */
SELECT
	PILOT_ID,
	COUNT(*) AS 'FLIGHTS'
FROM
	FLIGHT JOIN 
	CITY ON CITY_ID = CITY_DEP
WHERE
	CITY_NAME = 'MONTREAL'
GROUP BY
	PILOT_ID
HAVING
	COUNT(*) >= 2


/* 3) Display the planes (plane id, its description, localization(city) and the number 
of passenger) that are located in OTTAWA and their max passenger is greater than 200(>=) 
(display the result in the descending order of their max of passenger). */
SELECT
	PLA_ID,
	PLA_DESC,
	MAX_PASSENGER,
	CITY_NAME
FROM
	PLANE P JOIN 
	CITY C ON P.CITY_ID = C.CITY_ID
WHERE
	CITY_NAME = 'OTTAWA'
	AND MAX_PASSENGER >= 200
ORDER BY
	MAX_PASSENGER DESC


/* 4) Display the pilots (pilot id and name) 
who perform at least one departure from MONTREAL. */
SELECT
	DISTINCT P.PILOT_ID,
	LAST_NAME
FROM
	PILOT P JOIN 
	FLIGHT F ON P.PILOT_ID = F.PILOT_ID JOIN 
	CITY C ON C.CITY_ID = CITY_DEP
WHERE
	CITY_NAME = 'Montreal'


/* 5) Display the pilots (pilot id, name and plane description) who pilot a BOEING. */
SELECT
	P.PILOT_ID,
	LAST_NAME,
	FIRST_NAME,
	PLA_DESC
FROM
	PILOT P JOIN 
	FLIGHT F ON P.PILOT_ID = F.PILOT_ID JOIN 
	PLANE PL ON PL.PLA_ID = F.PLA_ID
WHERE
	PLA_DESC LIKE 'B%'


/* 6) Display the pilots (id and name) who earn the same salary 
as PETERS's or LAHRIRE's salary. 
(PETER and LAHRIRE are not included). */
SELECT
	PILOT_ID,
	LAST_NAME,
	FIRST_NAME,
	SALARY
FROM
	PILOT
WHERE
	(
	SALARY = (
				SELECT
					SALARY
				FROM
					PILOT
				WHERE
					LAST_NAME = 'PETERS'
				) OR 
	SALARY = (
				SELECT
					SALARY
				FROM
					PILOT
				WHERE
					LAST_NAME = 'LAHRIRE'
				)
	) AND 
	LAST_NAME NOT IN ('LAHRIRE', 'PETERS')


/* 7) Display the pilots (id, name and city name) 
who live in the same city as the localization city of the AIRBUS */
SELECT
	DISTINCT PILOT_ID,
	LAST_NAME,
	FIRST_NAME,
	CITY_NAME
FROM
	PILOT P JOIN 
	CITY C ON P.CITY_ID = C.CITY_ID JOIN 
	PLANE PL ON PL.CITY_ID = P.CITY_ID
WHERE
	PLA_DESC LIKE 'A%'


/* 8) Display the planes (description and maximum of passenger) 
that their max passenger is
greater (>) than the max passenger of all planes located in Montreal. */ 
WITH MAXMONTREAL AS(
					SELECT
						MAX(MAX_PASSENGER) AS 'max_pass'
					FROM
						PLANE P JOIN 
						CITY C ON P.CITY_ID = C.CITY_ID
					WHERE
						CITY_NAME = 'Montreal'
					)
SELECT
	PLA_DESC,
	MAX_PASSENGER
FROM
	PLANE P,
	MAXMONTREAL MM
WHERE
	MAX_PASSENGER > MM.MAX_PASS


/* 9) Display the planes (description and maximum of passenger) 
where their max passenger is
greater (>) than at least a max passenger of one plane located in Toronto. */ 
WITH MINTORONTO AS(
					SELECT
						MIN(MAX_PASSENGER) AS 'min_Pass'
					FROM
						PLANE P JOIN 
						CITY C ON P.CITY_ID = C.CITY_ID
					WHERE
						CITY_NAME = 'Toronto'
					)
SELECT
	PLA_DESC,
	MAX_PASSENGER
FROM
	PLANE P,
	MINTORONTO MT
WHERE
	MAX_PASSENGER > MT.MIN_PASS


/* 10) Display the number of pilots in service 
(pilot in service are pilots who make at least one flight). */ 
WITH PILOTSINSERVICE AS(
						SELECT
							DISTINCT PILOT_ID
						FROM
							FLIGHT
						)
SELECT
	COUNT(*) AS 'THE PILOTS IN SERVICE'
FROM
	PILOTSINSERVICE


/* 11) For each AIRBUS in service during the afternoon, 
display its description, its id and the 
departures and arrivals cities. */
SELECT
	P.PLA_ID AS 'PLANE ID',
	PLA_DESC AS 'PLANE DESCRIPTION',
	C1.CITY_NAME 'DEPART CITY',
	C2.CITY_NAME 'ARRIVAL CITY'
FROM
	FLIGHT F JOIN 
	PLANE P ON F.PLA_ID = P.PLA_ID JOIN 
	CITY C1 ON C1.CITY_ID = F.CITY_DEP JOIN 
	CITY C2 ON C2.CITY_ID = F.CITY_ARR
WHERE
	(
	DEP_TIME > 1200 AND 
	ARR_TIME > 1200
	) AND 
	PLA_DESC LIKE 'A%'
ORDER BY
	P.PLA_ID


 /* 12) Create a view containing the pilots (names) who do not make any flight. */
SELECT
	LAST_NAME,
	FIRST_NAME
FROM
	PILOT
WHERE
	PILOT_ID NOT IN (
					SELECT
						PILOT_ID
					FROM
						FLIGHT
					)
/* 13) Create a view which returns the pilot's id, 
his name, his salary as well as the plane's description 
that he pilots. */
SELECT
	DISTINCT F.PILOT_ID,
	LAST_NAME,
	FIRST_NAME,
	SALARY,
	PLA_DESC
FROM
	PILOT P JOIN 
	FLIGHT F ON P.PILOT_ID = F.PILOT_ID JOIN 
	PLANE PL ON PL.PLA_ID = F.PLA_ID


/* 14) Display the pilot's id and name, his piloting frequency. 
(piloting frequency is the number of flight). */
SELECT
	F.PILOT_ID,
	LAST_NAME,
	FIRST_NAME,
	COUNT(*) AS 'count'
FROM
	FLIGHT F JOIN 
	PILOT P ON F.PILOT_ID = P.PILOT_ID
GROUP BY
	F.PILOT_ID, LAST_NAME, FIRST_NAME
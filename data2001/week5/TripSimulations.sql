/* SETUP */

set search_path to NSWFuel;
drop table if exists SimulatedDrivers;
drop table if exists SimulatedTrips;


/* TABLE DEFINITIONS */

CREATE TABLE SimulatedDrivers (
  driver_id      SERIAL PRIMARY KEY,
  given_name     VARCHAR(100),
  family_name    VARCHAR(100),
  address        VARCHAR(200),
  vehicle_model  VARCHAR(100),
  vehicle_year   INTEGER
);

CREATE TABLE SimulatedTrips (
  trip_id    INTEGER,
  driver_id  INTEGER,
  station    VARCHAR(50),
  stop_time  TIME,
  PRIMARY KEY (trip_id, station)
);


/* DATA SIMULATION */

-- names are based on any duplicates amongst DATA2x01 students in 2025
create type demoFirstnames as enum ('Aaron', 'Abhinav', 'Abhishek', 'Aditya', 'Alex', 'Aman', 'Amrita', 'Andrew', 'Andy', 'Ariel', 'Arjun', 'Benjamin', 'Boyuan', 'Brian', 'Bryan', 'Charlie', 'Chuan', 'Cindy', 'Daniel', 'Edward', 'Ethan', 'Gary', 'Hao', 'Haochen', 'Harsh', 'Henry', 'Hongjie', 'Isaac', 'Jack', 'Jason', 'Jasper', 'Jeffrey', 'Jessica', 'Jia', 'Jiaqi', 'Jiayi', 'Jiaying', 'Jiayu', 'Joseph', 'Joshua', 'Joy', 'Junjie', 'Kelly', 'Kevin', 'Lan', 'Lara', 'Liam', 'Long', 'Marco', 'Matthew', 'Max', 'Michael', 'Muhammad', 'Nathanael', 'Nikhil', 'Oscar', 'Prisha', 'Richard', 'Robin', 'Rui', 'Ryan', 'Sam', 'Samantha', 'Sameer', 'Samuel', 'Sarah', 'Shreya', 'Thomas', 'Tom', 'Will', 'William', 'Wilson', 'Xi', 'Xiang', 'Yana', 'Yang', 'Yifan', 'Yikai', 'Yixuan', 'Yucheng', 'Yuhan', 'Yuhang', 'Yuhao', 'Yuqi', 'Yushan', 'Yutong', 'Zachariah', 'Zhiyi', 'Zihan', 'Zihao', 'Jarrod');
create type demoSurnames as enum ('Ali', 'Anand', 'Arora', 'Cao', 'Chan', 'Chang', 'Chen', 'Cheng', 'Cheung', 'Chi', 'Chow', 'Chowdhury', 'Dai', 'Dang', 'Ding', 'Du', 'Duong', 'Dutta', 'Fan', 'Fang', 'Gong', 'Guo', 'Han', 'He', 'Ho', 'Hou', 'Hu', 'Huang', 'Jain', 'Jiang', 'Jin', 'Kang', 'Khan', 'Khuu', 'Kim', 'Kumar', 'Lai', 'Lau', 'Le', 'Lee', 'Li', 'Liang', 'Liao', 'Lin', 'Liu', 'Lu', 'Luo', 'Ma', 'Mai', 'Meng', 'Nguyen', 'Palanivelu', 'Pan', 'Park', 'Pham', 'Qin', 'Shao', 'Sharma', 'Shen', 'Singh', 'Song', 'Su', 'Sun', 'Tang', 'Tao', 'Tian', 'Tran', 'Vu', 'Wan', 'Wang', 'Wei', 'Wu', 'Xia', 'Xie', 'Xu', 'Xue', 'Yadav', 'Yan', 'Yang', 'Yau', 'Ye', 'Yu', 'Yuan', 'Zeng', 'Zhang', 'Zhao', 'Zheng', 'Zhong', 'Zhou', 'Zhu', 'Jones');
-- car models are based on Australia's top 50 most popular: https://www.carsguide.com.au/car-news/top-100-new-cars-sold-in-australia-in-2021-from-toyota-hilux-and-ford-ranger-to-mitsubishis
create type demoModels as enum('Hilux', 'Ranger', 'RAV4', 'Corolla', 'i30', 'D-Max', 'CX-5', 'Prado', 'Triton', 'ZS', 'Cerato', 'BT-50', 'Navara', 'ASX', 'Outlander', 'LandCruiser', 'Tucson', 'Mazda3', 'X-Trail', 'MG3', 'CX-30', 'Camry', 'CX-3', 'Kona', 'Forester', 'MU-X', 'Outback', 'HiAce', 'XV', 'Kluger', 'Seltos', 'Everest', 'Sportage', 'Yaris Cross', 'Amarok', 'Stonic', 'Ute', 'CR-V', 'HS', 'Pajero', 'T60', 'CX-9', 'Picanto', 'C-HR', 'Eclipse', 'CX-8', 'T-Cross', 'HR-V', 'Carnival', 'Venue');
-- colours are based on Australia's most popular colours (quite boring!): https://www.youi.com.au/youi-news/study-which-car-colours-are-most-popular-and-which-are-the-safest
create type demoColours as enum ('White', 'Silver', 'Blue', 'Black', 'Grey', 'Red');
-- a simple unsourced list of common street suffixes
create type demoStreets as enum ('Avenue', 'Boulevard', 'Circuit', 'Close', 'Crescent', 'Drive', 'Esplanade', 'Lane', 'Parade', 'Place', 'Road', 'Street');


/* POPULATING THE TABLES */

insert into SimulatedDrivers
  select
    id,
  	(enum_range(null::demoFirstnames))[ceil(random() * array_length(enum_range(null::demoFirstnames), 1))],
  	(enum_range(null::demoSurnames))[ceil(random() * array_length(enum_range(null::demoSurnames), 1))],
    (ceil(1000*random())::text)||' '||(enum_range(null::demoSurnames))[ceil(random() * array_length(enum_range(null::demoSurnames), 1))]||' '||(enum_range(null::demoStreets))[ceil(12*random())],
  	(enum_range(null::demoColours))[ceil(random() * array_length(enum_range(null::demoColours), 1))]||' '||(enum_range(null::demoModels))[ceil(random() * array_length(enum_range(null::demoModels), 1))],
	(1998+ceil(random()*25))
  FROM (SELECT * FROM generate_series(1,1000) AS id) AS x;

insert into SimulatedTrips (
  with tripsgenerate as (
    select generate_series(1, 9999) trip_id, ceil(random() * 1000) driver_id, to_char((current_date + (random() * (interval '1 day'))), 'HH24:MI:SS')::time as start_time
  ),
  stopsgenerate as (
    select generate_series(1, 3333) trip_id, station, stop, totalkm, (random()+0.75)* sum(minutes) over (partition by generate_series(1, 3333) order by stop) as mins_in from Trips where highway = 'Princes' union
    select generate_series(1, 3333)+3333 trip_id, station, stop, totalkm, (random()+0.75)* sum(minutes) over (partition by generate_series(1, 3333)+3333 order by stop) as mins_in from Trips where highway = 'Pacific' union
    select generate_series(1, 3333)+6666 trip_id, station, stop, totalkm, (random()+0.75)* sum(minutes) over (partition by generate_series(1, 3333)+6666 order by stop) as mins_in from Trips where highway = 'Great Western'
  ),
  tripstops as (
    select *, max(mins_in) over (partition by trip_id order by stop) as sense_check from stopsgenerate 
  ),
  base as (
    select s.trip_id, t.driver_id, s.station, s.stop, (t.start_time + (round(s.mins_in*60) * interval '1 second'))::time as stop_time, s.totalkm
    from tripstops s
    join tripsgenerate t on s.trip_id = t.trip_id
    where s.mins_in = s.sense_check and random() < 0.5
  ),
  finalcheck as (
    select *,
      lag(stop_time) over (partition by trip_id order by stop) as prev_time,
      lag(totalkm) over (partition by trip_id order by stop) as prevkm
    from base
  )
  select trip_id, driver_id, station, stop_time
  from finalcheck
  where extract(epoch from (stop_time-prev_time)) > 120
    and (totalkm-prevkm)/(extract(epoch from (stop_time-prev_time))/3600) <= 120
  order by trip_id, stop_time
);


/* COMPLETION */

-- clear the created data types as no longer required
drop type if exists demoFirstnames;
drop type if exists demoSurnames;
drop type if exists demoModels;
drop type if exists demoColours;
drop type if exists demoStreets;

commit;
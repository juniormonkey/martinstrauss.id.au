
(function () {
   var tz = new TimeZone('America/Los_Angeles');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(1, 0, 11, 2, 0, 0),
              tz_weekOfMonth(2, 0, 3, 2, 0, 0),
              -480, -420);
   tz_register('PDT', tz);
   tz_register('PST', tz);
   tz_register('America/Los_Angeles', tz);
 })();


(function () {
   var tz = new TimeZone('America/New_York');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(1, 0, 11, 2, 0, 0),
              tz_weekOfMonth(2, 0, 3, 2, 0, 0),
              -300, -240);
   tz_register('EDT', tz);
   tz_register('EST', tz);
   tz_register('America/New_York', tz);
 })();


(function () {
   var tz = new TimeZone('America/Chicago');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(1, 0, 11, 2, 0, 0),
              tz_weekOfMonth(2, 0, 3, 2, 0, 0),
              -360, -300);
   tz_register('CDT', tz);
   tz_register('CST', tz);
   tz_register('America/Chicago', tz);
 })();


(function () {
   var tz = new TimeZone('America/Denver');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(1, 0, 11, 2, 0, 0),
              tz_weekOfMonth(2, 0, 3, 2, 0, 0),
              -420, -360);
   tz_register('MDT', tz);
   tz_register('MST', tz);
   tz_register('America/Denver', tz);
 })();


(function () {
   var tz = new TimeZone('America/Phoenix');
   tz_addRule(tz, 1970,
              tz_dayOfMonth(1, 1, 0, 0, 0),
              tz_dayOfMonth(1, 1, 0, 0, 0),
              -420, -420);
   tz_register('America/Phoenix', tz);
 })();


(function () {
   var tz = new TimeZone('Asia/Calcutta');
   tz_addRule(tz, 1970,
              tz_dayOfMonth(1, 1, 0, 0, 0),
              tz_dayOfMonth(1, 1, 0, 0, 0),
              330, 330);
   tz_register('IST', tz);
   tz_register('Asia/Calcutta', tz);
 })();


(function () {
   var tz = new TimeZone('America/Sao_Paulo');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(3, 0, 2, 0, 0, 0),
              tz_weekOfMonth(2, 0, 10, 0, 0, 0),
              -180, -120);
   tz_register('BRST', tz);
   tz_register('BRT', tz);
   tz_register('America/Sao_Paulo', tz);
 })();


(function () {
   var tz = new TimeZone('America/Argentina/Buenos_Aires');
   tz_addRule(tz, 1970,
              tz_dayOfMonth(1, 1, 0, 0, 0),
              tz_dayOfMonth(1, 1, 0, 0, 0),
              -180, -180);
   tz_register('ART', tz);
   tz_register('America/Argentina/Buenos_Aires', tz);
 })();


(function () {
   var tz = new TimeZone('Europe/Brussels');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(-1, 0, 10, 3, 0, 0),
              tz_weekOfMonth(-1, 0, 3, 2, 0, 0),
              60, 120);
   tz_register('CEST', tz);
   tz_register('CET', tz);
   tz_register('Europe/Brussels', tz);
 })();


(function () {
   var tz = new TimeZone('Europe/Dublin');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(-1, 0, 10, 2, 0, 0),
              tz_weekOfMonth(-1, 0, 3, 1, 0, 0),
              0, 60);
   tz_register('Europe/Dublin', tz);
 })();


(function () {
   var tz = new TimeZone('Asia/Hong_Kong');
   tz_addRule(tz, 1970,
              tz_dayOfMonth(1, 1, 0, 0, 0),
              tz_dayOfMonth(1, 1, 0, 0, 0),
              480, 480);
   tz_register('HKT', tz);
   tz_register('Asia/Hong_Kong', tz);
 })();


(function () {
   var tz = new TimeZone('Europe/London');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(-1, 0, 10, 2, 0, 0),
              tz_weekOfMonth(-1, 0, 3, 1, 0, 0),
              0, 60);
   tz_register('BST', tz);
   tz_register('GMT', tz);
   tz_register('Europe/London', tz);
 })();


(function () {
   var tz = new TimeZone('America/Mexico_City');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(-1, 0, 10, 2, 0, 0),
              tz_weekOfMonth(1, 0, 4, 2, 0, 0),
              -360, -300);
   tz_register('America/Mexico_City', tz);
 })();


(function () {
   var tz = new TimeZone('Asia/Seoul');
   tz_addRule(tz, 1970,
              tz_dayOfMonth(1, 1, 0, 0, 0),
              tz_dayOfMonth(1, 1, 0, 0, 0),
              540, 540);
   tz_register('KST', tz);
   tz_register('Asia/Seoul', tz);
 })();


(function () {
   var tz = new TimeZone('Europe/Moscow');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(-1, 0, 10, 3, 0, 0),
              tz_weekOfMonth(-1, 0, 3, 2, 0, 0),
              180, 240);
   tz_register('MSD', tz);
   tz_register('MSK', tz);
   tz_register('Europe/Moscow', tz);
 })();


(function () {
   var tz = new TimeZone('Australia/Sydney');
   tz_addRule(tz, 1970,
              tz_weekOfMonth(1, 0, 4, 3, 0, 0),
              tz_weekOfMonth(1, 0, 10, 2, 0, 0),
              600, 660);
   tz_register('AEST', tz);
   tz_register('Australia/Sydney', tz);
 })();


(function () {
   var tz = new TimeZone('Asia/Jerusalem');
   tz_addRule(tz, 1970,
              tz_dayOfMonth(1, 1, 0, 0, 0),
              tz_dayOfMonth(1, 1, 0, 0, 0),
              120, 120);
   tz_register('Asia/Jerusalem', tz);
 })();


(function () {
   var tz = new TimeZone('Asia/Tokyo');
   tz_addRule(tz, 1970,
              tz_dayOfMonth(1, 1, 0, 0, 0),
              tz_dayOfMonth(1, 1, 0, 0, 0),
              540, 540);
   tz_register('JST', tz);
   tz_register('Asia/Tokyo', tz);
 })();


(function () {
   var tz = new TimeZone('Asia/Chongqing');
   tz_addRule(tz, 1970,
              tz_dayOfMonth(1, 1, 0, 0, 0),
              tz_dayOfMonth(1, 1, 0, 0, 0),
              480, 480);
   tz_register('Asia/Chongqing', tz);
 })();


(function () {
   var tz = new TimeZone('Asia/Singapore');
   tz_addRule(tz, 1970,
              tz_dayOfMonth(1, 1, 0, 0, 0),
              tz_dayOfMonth(1, 1, 0, 0, 0),
              480, 480);
   tz_register('SGT', tz);
   tz_register('Asia/Singapore', tz);
 })();


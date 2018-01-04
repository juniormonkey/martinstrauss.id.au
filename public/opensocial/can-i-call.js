var weekdays = [
  "Sun",
  "Mon",
  "Tue",
  "Wed",
  "Thu",
  "Fri",
  "Sat"
]

var table = document.getElementById('table');
var dropdown1 = document.getElementById('tz1');
var dropdown2 = document.getElementById('tz2');

var prefs = new _IG_Prefs();

function appendRowToTable(time, times, parity) {
  var lastRow = table.rows.length;
  var row = table.insertRow(lastRow);
  row.id = time.getTime();
  var cells = new Array();
  for (var i = 0; i < times.length; i++) {
    cells[i] = row.insertCell(i);
    if (isDay(times[i])) cells[i].className = 'day' + parity;
    else if (isNight(times[i])) cells[i].className = 'night' + parity;
    else if (isTwilight(times[i])) cells[i].className = 'evening' + parity;
    var text = document.createTextNode(formatHour(times[i]));
    cells[i].appendChild(text);
  }
}

function addTimeRowToTable(time, times) {
  // console.log("addTimeRowToTable()");
  var rowIdx = 0;
  for (var i = 0; i < table.rows.length; i++) {
    if (parseInt(table.rows[i].id) > time.getTime()) {
      rowIdx = i;
      break;
    }
  }
  var row = table.insertRow(rowIdx);
  row.id = 'currentTime'

  var cells = new Array();
  for (var i = 0; i < times.length; i++) {
    cells[i] = row.insertCell(i);
    if (isDay(times[i])) cells[i].className = 'nowDay';
    else if (isNight(times[i])) cells[i].className = 'nowNight';
    else if (isTwilight(times[i])) cells[i].className = 'nowEvening';
    var text = document.createTextNode(formatTime(times[i]));
    cells[i].appendChild(text);
  }
}

function between(time, time1, time2) {
  if (time1.getTime() > time2.getTime()) { 
    var time2Tomorrow = new Date();
    time2Tomorrow.setTime(time2.getTime() + 24 * 60 * 60 * 1000);

    var time1Yesterday = new Date();
    time1Yesterday.setTime(time1.getTime() - 24 * 60 * 60 * 1000);

    return between(time, time1Yesterday, time2) ||
           between(time, time1, time2Tomorrow);
  }

  return time1.getTime() <= time.getTime() && time.getTime() < time2.getTime();
}

function isDay(time) {
  var nineAM = new Date();
  nineAM.setTime(time.getTime());
  nineAM.setHours(prefs.getInt('nineAM'), 0, 0, 0);

  var fivePM = new Date();
  fivePM.setTime(time.getTime());
  fivePM.setHours(prefs.getInt('fivePM'), 0, 0, 0);

  return between(time, nineAM, fivePM);
}

function isNight(time) {
  var bedtime = new Date();
  bedtime.setTime(time.getTime());
  bedtime.setHours(prefs.getInt('bedtime'), 0, 0, 0);

  var wakeup = new Date();
  wakeup.setTime(time.getTime());
  wakeup.setHours(prefs.getInt('wakeUp'), 0, 0, 0);

  return between(time, bedtime, wakeup);
}

function isTwilight(time) {
  return isMorning(time) || isEvening(time);
}

function isMorning(time) {
  var wakeup = new Date();
  wakeup.setTime(time.getTime());
  wakeup.setHours(prefs.getInt('wakeUp'), 0, 0, 0);

  var nineAM = new Date();
  nineAM.setTime(time.getTime());
  nineAM.setHours(prefs.getInt('nineAM'), 0, 0, 0);

  return between(time, wakeup, nineAM);
}

function isEvening(time) {
  var fivePM = new Date();
  fivePM.setTime(time.getTime());
  fivePM.setHours(prefs.getInt('fivePM'), 0, 0, 0);

  var bedtime = new Date();
  bedtime.setTime(time.getTime());
  bedtime.setHours(prefs.getInt('bedtime'), 0, 0, 0);

  return between(time, fivePM, bedtime);
}

function localtime(time, office) {
  // console.log("localtime()");
  var loctime = new Date();

  var iCalTime = new ICAL_DateTime(time.getFullYear(),
                                   time.getMonth() + 1,
                                   time.getDate(),
                                   time.getHours(),
                                   time.getMinutes(),
                                   time.getSeconds());

  var timezone = tz_lookupByTzid(timezones[office])[0];

  loctime.setTime(time.getTime() +
                  (time.getTimezoneOffset() * 60000) +
                  (tz_offset(timezone, iCalTime) * 60000)
                 );

  return loctime;
}

function formatTime(time) {
  timestring = weekdays[time.getDay()] + ' ' + time.getHours() + ':';

  minsString = new String(time.getMinutes());
  if(minsString.length == 1) minsString = '0' + minsString;

  timestring += minsString;

  return timestring;
}

function formatHour(time) {
  timestring = weekdays[time.getDay()] + ' ' + time.getHours() + ':00';

  return timestring;
}

function initTable() {
  // console.log('initTable called');
  var startTime = new Date();
  startTime.setHours(startTime.getHours() - 1, 0, 0, 0);

//    console.log("First hour: " + startTime);
  var tz1 = dropdown1.options[dropdown1.selectedIndex].value
  var tz2 = dropdown2.options[dropdown2.selectedIndex].value

  // console.log("Timezones: " + tz1 + " " + tz2);

  for(var i = 0; i < 24; i++) {
    var hour = new Date();
    hour.setTime(startTime.getTime() + i * 3600000);
    var times = [
      localtime(hour, tz1),
      localtime(hour, tz2)
    ];
    appendRowToTable(hour, times, i % 2);
  }
}

function updateCurrentTime() {
  // console.log('updateCurrentTime()');
  var timeRow = document.getElementById('currentTime');

  if(timeRow != null) {
    try {
      table.deleteRow(timeRow.rowIndex);
    }
    catch (e) {
      console.log('Gargh, rowIndex threw an exception, we have to do this the painful way');
      for (var i = 0; i < table.rows.length; i++) {
        if (table.rows[i].id == 'currentTime') {
          table.deleteRow(i);
          break;
        }
      }
    }
  }

  var tz1 = dropdown1.options[dropdown1.selectedIndex].value
  var tz2 = dropdown2.options[dropdown2.selectedIndex].value

  var time = new Date();
  var times = [
    localtime(time, tz1),
    localtime(time, tz2)
  ];

  addTimeRowToTable(time, times);
}

function initDropdown(dropdown) {
  for (loc in offices) {
    var opt = document.createElement('option');
    opt.value = loc;
    var text = document.createTextNode(offices[loc]);
    opt.appendChild(text);
    dropdown.appendChild(opt);
  }
}

function initDropdowns() {
  initDropdown(dropdown1);
  initDropdown(dropdown2);

  var tz1= prefs.getString('tz1');
  select(dropdown1, tz1);
  var tz2= prefs.getString('tz2');
  select(dropdown2, tz2);
}

function select(dropdown, option) {
  for (var i = 0; i < dropdown.options.length; i++) {
    if (dropdown.options[i].value == option) {
      dropdown.selectedIndex = i;
      return;
    }
  }
  dropdown.selectedIndex = 0;
}

function changeTimezones() {
  // console.log('changeTimezones called');
  try {
    prefs.set('tz1', dropdown1.options[dropdown1.selectedIndex].value);
    prefs.set('tz2', dropdown2.options[dropdown2.selectedIndex].value);
    // console.log('preferences saved');
  } catch (e) {
    console.log("Unable to save preferences!");
  }

  //TODO: can we redraw only individual columns?
  while ( table.rows.length > 1 ) table.deleteRow(-1);
  // console.log('table emptied');
  initTable();
}

function init() {
  alert('init() called');
  initDropdowns();

  initTable();

  updateCurrentTime();
  // try to sync the update with the system clock
  window.setTimeout('startInterval()', (60 - new Date().getSeconds()) * 1000 + 5);
}

function startInterval() {
  window.setInterval('updateCurrentTime()', 60000);
  updateCurrentTime();
}


//_IG_RegisterOnloadHandler(init());
init();
alert("Hello!");

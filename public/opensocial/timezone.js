// Copyright 2006 Google Inc.
// All Rights Reserved.

// msamuel@google.com

// Library for client side timezone conversions.

/**
 * given a timezone id, fetch a list of the timezones that match that id.
 * Some timezone ids, such as EST, are ambiguous, so this returns a list.
 */
function tz_lookupByTzid(tzid) {
  return TIMEZONE_REGISTRY_[tzid];
}

/**
 * the offset, in number of minutes from UTC, of the given timezone on the given
 * date.
 */
function tz_offset(timeZone, datetime) {
  var year = datetime.year;
  // check the cache
  var rule = tz_ruleForYear_(timeZone, year);
  if (rule.dstOffsetMins_ === rule.standardOffsetMins_) {
    return rule.dstOffsetMins_;
  }
  var dates = rule.dstBoundaryCache_[year];
  if (!dates) {
    dates = [ rule.dstStartForYear_(year).getComparable(),
              rule.dstEndForYear_(year).getComparable() ];
    if (dates[0] > dates[1]) {
      var tmp = dates[0];
      dates[0] = dates[1];
      dates[1] = tmp;
      dates.isDaylight_ = true;
    } else {
      dates.isDaylight_ = false;
    }
    if (++rule.dstBoundaryCache_.size > 10) {
      rule.dstBoundaryCache_ = { size: 0 };
    }
    rule.dstBoundaryCache_[year] = dates;
  }
  var isDaylightSavings = dates.isDaylight_ !==
                          (datetime.getComparable() < dates[0]
                           || datetime.getComparable() > dates[1]);
  return isDaylightSavings ? rule.dstOffsetMins_ : rule.standardOffsetMins_;
}

function tz_toUtc(timeZone, date) {
  if (!(date instanceof ICAL_DateTime)) { return date; }
  var b = ical_builderCopy(date);
  b.minute -= tz_offset(timeZone, date);
  return b.toDateTime();
}

function tz_fromUtc(timeZone, date) {
  if (!(date instanceof ICAL_DateTime)) { return date; }
  var b = ical_builderCopy(date);
  b.minute += tz_offset(timeZone, date);
  return b.toDateTime();
}

/** register a timeZone in the global timeZone registry */
function tz_register(tzid, timeZone) {
  if (tzid in TIMEZONE_REGISTRY_) {
    throw new Error("Duplicate timezone " + tzid);
  }
  if (!(timeZone instanceof TimeZone)) {
    throw new Error("Not a timezone: " + timeZone);
  }
  var tzs = TIMEZONE_REGISTRY_[tzid];
  if (!tzs) { TIMEZONE_REGISTRY_[tzid] = tzs = []; }
  tzs.push(timeZone);
}

/**
 * add a rule covering a range of years for the given timeZone.
 * @param timeZone {TimeZone} to be modified.
 * @param year0 {int} the first year that the rule affects.
 * @param dstStartForYear {ICAL_DateTime function (int)} a function that takes
 *   a year and returns the date-time at which time switches from standard to
 *   daylight savings.
 * @param dstEndForYear {ICAL_DateTime function (int)} a function that takes
 *   a year and returns the date-time at which time switches from daylight
 *   savings to standard.
 * @param standardOffsetMins {int} the number of minutes difference between
 *   this timeZone and UTC outside daylight savings.
 * @param standardOffsetMins {int} the number of minutes difference between
 *   this timeZone and UTC during daylight savings.
 */
function tz_addRule(
    timeZone, year0, dstStartForYear, dstEndForYear,
    standardOffsetMins, dstOffsetMins) {
  var rule = new TzRule_(year0, dstStartForYear, dstEndForYear,
                         standardOffsetMins, dstOffsetMins);

  // find insertion index
  var i = 0;
  var lo = 0;
  var hi = timeZone.rules_.length - 1;
  while (hi >= lo) {
    i = (hi + lo) >> 1;
    var cmp = timeZone.rules_[i].year0_ - year0;
    if (0 === cmp) {
      break;
    } else if (cmp < 0) {
      lo = i + 1;
    } else {
      hi = i - 1;
    }
  }
  if (i < timeZone.rules_.length && year0 > timeZone.rules_[i].year0_) { ++i; }

  // splice rule into place
  timeZone.rules_.splice(i, 0, rule);

  // if the rule satisfies covers nowYear_, then cache it
  if (year0 <= timeZone.nowYear_ &&
      (i + 1 == timeZone.rules_.length ||
      timeZone.rules_[i + 1].year0_ > timeZone.nowYear_)) {
    timeZone.nowRule_ = rule;
  }
}

/** maps tzids to lists of TimeZones. */
var TIMEZONE_REGISTRY_ = {};

function TimeZone(tzid) {
  /** a timeZone identifier such as "America/Los Angeles" or "PDT" */
  this.tzid_ = tzid;
  /** the current year. */
  this.nowYear_ = new Date().getFullYear();
  /** the rule for the current year. */
  this.nowRule_ = null;
  /** timeZone rules sorted by years. */
  this.rules_ = [];
}
TimeZone.prototype.toString = function () {
  return this.tzid_;
};

function TzRule_(year0, dstStartForYear, dstEndForYear,
                 standardOffsetMins, dstOffsetMins) {
  /** {int} the first year that the rule affects. */
  this.year0_ = year0;
  /**
   * {ICAL_DateTime function (int)} a function that takes a year and returns
   * the date-time at which time switches from standard to daylight savings.
   */
  this.dstStartForYear_ = dstStartForYear;
   /**
    * {ICAL_DateTime function (int)} a function that takes a year and returns
    * the date-time at which time switches from daylight savings to standard.
    */
  this.dstEndForYear_ = dstEndForYear;
  /**
   * {int} the number of minutes difference between this timeZone and UTC
   * outside daylight savings.
   */
  this.standardOffsetMins_ = standardOffsetMins;
   /**
    * {int} the number of minutes difference between this timeZone and UTC
    * during daylight savings.
    */
  this.dstOffsetMins_ = dstOffsetMins;
  /**
   * maps years to a pair of date-times indicating timeZone boundaries.
   * Maintained by tz_offset.
   */
  this.dstBoundaryCache_ = { size: 0 };
}
TzRule_.prototype.toString = function () {
  return '[TzRule_ ' + this.year0_ + ', dst=' + this.dstOffsetMins_ + ', std=' +
    this.standardOffsetMins_ + ']';
}

var TZ_DEFAULT_RULE_ = new TzRule_(
    -Infinity,
    function (y) { return new DateTimeValue(y, 1, 1, 0, 0, 0); },
    function (y) { return new DateTimeValue(y, 1, 1, 0, 0, 0); },
    0, 0);

function tz_ruleForYear_(timeZone, year) {
  if (year === timeZone.nowYear_) { return timeZone.nowRule_; }

  var i = 0;
  var lo = 0;
  var hi = timeZone.rules_.length - 1;
  while (hi >= lo) {
    i = (hi + lo) >> 1;
    var cmp = timeZone.rules_[i].year0_ - year;
    if (0 === cmp) {
      break;
    } else if (cmp < 0) {
      lo = i + 1;
    } else {
      hi = i - 1;
    }
  }
  if (i > 0 && (i >= timeZone.rules_.length ||
                year < timeZone.rules_[i].year0_)) {
    --i;
  }

  return timeZone.rules_[i] || TZ_DEFAULT_RULE_;
}

// These functors return functions that return a date for a given year --
// basically an optimized subset of yearly rrules.
/**
 * a functor that returns a function, that, given a year, returns the date-time
 * that falls on the given day of the week in the given week of the given month.
 */
function tz_weekOfMonth(week, dow, month, hr, mi, se) {
  return function (year) {
    var dow0 = ICAL_firstDayOfWeekInMonth(year, month);
    var firstOccurrence = 1 + (dow - dow0 + 7) % 7;
    var nOccurrences =
      1 + (((ICAL_daysInMonth(year, month) - firstOccurrence) / 7) | 0);
    var absweek = week >= 1 ? week : nOccurrences + week + 1;
    var date = Math.max(1, firstOccurrence + (absweek - 1) * 7);
    return new ICAL_DateTime(year, month, date, hr, mi, se);
  };
}
/**
 * a functor that returns a function, that, given a year, returns the date-time
 * that falls on the given day of the month in the given month.
 */
function tz_dayOfMonth(date, month, hr, mi, se) {
  return function (year) {
    return new ICAL_DateTime(year, month, date, hr, mi, se);
  };
}

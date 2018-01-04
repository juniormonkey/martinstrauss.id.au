// TODO: check for uniqueness of "wantstomeet" entries.
// TODO: eliminate common friends from the list of people you might want to meet
// TODO: eliminate friends already on my "wantstomeet" list from the list
// TODO: write each request onto the activity stream

// TODO: some way to introduce people?

function safeParseJSON(str) {
  if (!str) {
    return {};
  }
  try {
    return str.parseJSON();
  } catch (e) {
    console.log("error parsing JSON: " + e);
    return {};
  }
}

function byId(x) {
    return document.getElementById(x);
}

function SimpleTable() {
  var html = "<div>";
  this.addRow = function(row) {
    html += "<div class='listitemchk'>" +
      row +
      "</div><div class='listdivi'></div>";
  };
  this.addPersonRow = function(person, row) {
    this.addRow(
      "<img class='listimg' src='" + person.getField(opensocial.Person.Field.THUMBNAIL_URL) + "'/>" +
      "<h3 class='smller'>" + person.getDisplayName() + "</h3>" +
      "<div class='para'>" +
      row +
      "</div>"
    );
  };
  this.getHtml = function() {
    return html + "</div>";
  };
}


function getSurface() {
    return document.location.toString().match(/mode=canvas/) ? "canvas" : "profile";
}

var IntroduceMe = {};

IntroduceMe.data = {};

IntroduceMe.render = function(data) {
    IntroduceMe.data = data;
    if (getSurface() == "canvas") {
        var html = "Welcome, " + data.getViewer().getDisplayName();

        var table = new SimpleTable();
        var friends = data.getViewerFriends().asArray();
        var numFriends = 0;
        for (var i=0; i<friends.length; i++) {
            var introductions = safeParseJSON(
                data.getDataFor(friends[i])['wantstomeet']);
            if(introductions.length > 0) {
                var wantstomeet = "Wants to meet:";
                var first = true;
                for (var j=0; j<introductions.length; j++) {
                    //for(member in introductions[j].obj_)
                    //    console.log("MEMBER: " + member + " = " + introductions[j].obj_[member]);
                    if(first) first = false;
                    else wantstomeet += ",";
                    wantstomeet += " " + introductions[j].obj_.Name;
                }
            
                table.addPersonRow(friends[i], wantstomeet);
                numFriends++;
            }
        }
        if(numFriends > 0) {
            html += table.getHtml();
            byId("main").innerHTML = html;
        } else {
            byId("main").innerHTML = "No introductions pending!";
        }
    } else {

        var html = data.getOwner().getDisplayName() + "'s friends:";

        var table = new SimpleTable();
        var friends = data.getOwnerFriends().asArray();
        for (var i=0; i<friends.length; i++) {
            if(friends[i].getId() != data.getViewer().getId()) {
            // and friend not in data.getViewerFriends().asArray()
            // and friend not in data.getDataFor(data.getViewer())['wantstomeet']
                table.addPersonRow(friends[i], '<a href=# onclick="introduce(\'' + i + '\')">Introduce me</a>');
            }
        }
        html += table.getHtml();
        byId("main").innerHTML = html;
    }
}

function introduce(personIndex) {
    var person = IntroduceMe.data.getOwnerFriends().asArray()[personIndex];
    var text = "This will ask ";
    text += IntroduceMe.data.getOwner().getDisplayName();
    text += " to introduce ";
    text += person.getDisplayName();
    text += " to ";
    text += IntroduceMe.data.getViewer().getDisplayName();
    text += "\n";
    text += "in other words, getViewerData()[length] = " + person.getDisplayName();
    alert(text);

    var introductions = safeParseJSON(
        IntroduceMe.data.getViewerData()['wantstomeet']);

    if (introductions.length == undefined) introductions = new Array();

    introductions[introductions.length] = person;

    var introductionsJSON = introductions.toJSONString();
    var req = opensocial.newDataRequest();
    req.add(req.newUpdatePersonAppDataRequest('VIEWER', 
                                              'wantstomeet',
                                              introductionsJSON));
    req.send();
}

function initGadget() {
    var mode = (getSurface() == "canvas") ? "VIEWER" : "OWNER";
    SocialNorms.createSocialAppOnLoad(IntroduceMe, mode, ["wantstomeet"]);
}

initGadget();

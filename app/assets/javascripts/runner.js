var voteCountArray = [];
var venueCount = 0;
var currentEventsArray = [];


function voteSort() {
    var $list = $("#venueList .listItem");

    $list.sort(function(a, b) {
        var aVotes = $(a).children(".voteCount-container").children(".voteCount").data("votecount");
        //console.log("A:" + aVotes);
        var bVotes = $(b).children(".voteCount-container").children(".voteCount").data("votecount");
        //console.log("B:" + bVotes);

        return parseInt(bVotes) - parseInt(aVotes);
    });
    $.each($list, function(index, li){
        $("#venueList").append(li);
    });
}

function overlay() {
    if( $("#userEntry").css("visibility") == "hidden") {
        $("#userEntry").css("visibility", "visible");
        $("#userEntryButton").css("visibility", "hidden");
    }
    else {
        $("#userEntry").css("visibility", "hidden");
        $("#userEntryButton").css("visibility", "visible");
    }
}

function calculateVoteMeter(venue_id, venue_votes, total_votes ) {
    percent_votes = 100*venue_votes/total_votes;
    color = "#5ABE59" //votes are > 75%

    if (percent_votes >= 40 && percent_votes < 65) {
        color = "yellow";
    }

    else if(percent_votes < 40 && percent_votes >= 20) {
        color = "orange"
    }

    else if(percent_votes < 20 || venue_votes == 0) {
        color = "red"
    }

    $("#voteMeter-cover-" + (venue_id.toString())).css('left', (percent_votes === 0 ? '5%' : percent_votes.toString() + '%'));
    $("#voteMeter-value-" + (venue_id.toString())).css('background', color);


}

/********************
COUTNDOWN CREATION FUNCTIONS
 *********************/

function createCountdown(end_date, selector) {
    var dateString = parseDate(end_date);
    //make dateString firefox/IE compatible
    dateString = dateString.replace(/-/g, "/");
    var end_timer = new Date(dateString);
    now = new Date();
    if(end_timer - now > 0) {
        var t = setInterval(function() {updateCountdown(end_timer, selector)} , 1000);
    }

}


//creates countdown timers in events#index view for each event
function createTimersinIndex()
{
     //if timeLeft is less than 1 day, show countdown clock
    	var eventDate = [];

    	for (var i = 0; i <  gon.totalIndexEvents; i++) { 
    		var dateFromView = $("#eventIndexTimer" + i).data("date");
            //console.log(dateFromView);
    		var dateString = parseDate(dateFromView)
            //console.log(dateString);

            //make dateString firefox/IE compatible
            dateString = dateString.replace(/-/g, "/");
    		eventDate.push(new Date(dateString));
    	}
    	for(var i=0; i < eventDate.length; i++) {
    		var x= eventDate[i];
    		var now = new Date();
            var msInDay = 1000*24*60*60;
            var timeDiff = (eventDate[i]-now)/(msInDay)
            //console.log();
    		if (timeDiff > 0 && timeDiff < 1 ) {
    	  		setInterval(function(x, i) {return function() {updateCountdown(x, "#eventIndexTimer" + i)}}(x, i) , 1000);
                $("#eventIndexTimer" + i.toString()).addClass('red');
    	  	}
            else if (timeDiff < 0) {
                $("#eventIndexTimer" + i.toString()).html("In Progress");
                $("#eventIndexTimer" + i.toString()).addClass('blue');
            }

    	}
}

//parses date string object returned from rails events#index view
function parseDate(date) {
	var dateStrings = date.split(" ");

	//dateStrings[0] = "2013-01-05", dateStrings[1] = "16:00:00", for example
	return dateStrings[0] + " " + dateStrings [1];
}


//updates countdown timer for upcoming events
function updateCountdown(d, selector) {
    var currentDate = new Date();
    if (d - currentDate <= 0) {
        $(selector).html("Time's Up!");
    }
    else {

        var timeMS = Math.abs(d - currentDate);
        var seconds = Math.round(timeMS/1000);
        var minutes = Math.floor(seconds/60);
        seconds %= 60;
        var hours = Math.floor(minutes/60);
        minutes %= 60;
        var days = Math.floor(hours/24);
        hours %= 24;

        $(selector).html(days + ((days === 1) ? " Day": " Days") + " " + numChecker(hours) + ":" + numChecker(minutes) + ":" + numChecker(seconds));
    }
}

//converts numbers to two digit strings for countdown timer
function numChecker(num) {
    if(num <10){
        return "0" + num;
    }
    return num;
}
/********************
END COUTNDOWN CREATION FUNCTIONS
 *********************/


/********************
 $(document).ready() function
 *********************/
$(function() {
	   //var dateFromIndex = $("#eventIndexTimer").data("date");
	   //var dateIndex = $(".eventIndexTimer").data("index");
	   //var eventDate = new Date(dateFromIndex);
    	//var t = setInterval(function() {updateCountdown(eventDate, dateIndex)} , 1000);

});
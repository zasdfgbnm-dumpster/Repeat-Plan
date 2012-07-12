//convert date to string with format YYYY-MM-DD
function dateToString(date){
    var ret = "";
    ret += date.getFullYear();
    ret += "-";
    var month = date.getMonth()+1;
    ret += month<10?"0"+month:month;
    ret += "-";
    var day = date.getDate();
    ret += day<10?"0"+day:day;
    return ret;
}

//get konsolekalendar command line
function getCommandLine(date,summary,description){
    return new Array("--add",
		     "--allow-gui",
		     "--date",dateToString(date),
		     "--summary",summary,
		     "--description",description
		    );
}

function addToCalendar(title,description) {
    var days_string = String(plasmoid.readConfig("days"));
    var days_string_array = days_string.split(" ");
    var n = days_string_array.length;
    //Here we get the current date once and make a copy everytime we
    //use it in order to avoid mistakes when a new day come before
    //the returning of this function;
    var today = new Date();
    for( i in days_string_array ){
	var day = today.getDate() + Number(days_string_array[i]);
	var date_of_event = new Date(today);
	date_of_event.setDate(day);
	var cmd_args = getCommandLine(date_of_event,summaryTextField.text
				     ,descriptionTextArea.text);
	if(!plasmoid.runCommand("konsolekalendar",cmd_args))
	    return false;
    }
    return true;
} 

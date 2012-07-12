//convert date to string with format YYYY-MM-DD
function dateToString(date) {
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

//get konsolekalendar command line arguments
function getCommandLineArgs(date,summary,description) {
    return new Array("--add",
		     "--allow-gui",
		     "--date",dateToString(date),
		     "--summary",summary,
		     "--description",description
		    );
}

//get the date n days after date
function nDaysAfter(date,n) {
	var ret = new Date(date);
	ret.setDate(ret.getDate()+Number(n));
	return ret;
}

function addToCalendar(title,description) {
    var exec = "konsolekalendar";
    //exec = "echo"; //debug
    var days = String(plasmoid.readConfig("days")).split(" ");
    //Here we get the current date once and make a copy everytime we
    //use it in order to avoid mistakes when a new day come before
    //the returning of this function;
    var today = new Date();
    for( i in days ){
	var cmd_args = getCommandLineArgs(nDaysAfter(today,days[i]),
					  summaryTextField.text,
					  descriptionTextArea.text);
	if(!plasmoid.runCommand(exec,cmd_args)) return false;
    }
    return true;
} 

 
            
var develMode = true;
dbg("VAR develMode = ", develMode);
dbg("IMPORT scorm_generic.js SUCCESS");
var ScormApi = null;
dbg("VAR ScormApi = ", ScormApi);
var lesson_mode = 'browse';
dbg("VAR lesson_mode = ", lesson_mode);
var lesson_status;
dbg("VAR lesson_status = ", lesson_status);
var Date1 = new Date();
var StartTime = Date1.getTime();
StartTime = StartTime;
dbg("VAR StartTime = ", StartTime);
findApiAndInit();
evaluateStatus();

function findApiAndInit() {
dbg("CALL findApiAndInit");
if (ScormApi) {
        dbg("init call can not be processed ScormApi has allready been found FAILED");
        return false;
    }
    dbg("Trying to connect to SCORM RTE...")
    findScormApi();
    if (! ScormApi) {
        dbg("SCORM RTE not found FAILED");
        dbg("Continuing without LMS support.");
    } else {
        dbg("SCORM RTE found SUCCESS")
        var rv = ScormApi.LMSInitialize('') .toString();
        dbg("LMSInitialize " + rv);
        if (rv != 'true' && rv != 't' && rv != '1') {
            dbg("SCORM RTE communication failed FAILED");
            ScormApi = null;
            dbg("VAR ScormApi = ", ScormApi);
        } else {
            var Err = ScormApi.LMSGetLastError();
            dbg("LMSGetLastError() " + Err);
            dbg("SCORM RTE comminication established SUCCESS");
            //Alberto auskommentiert hier
            //window.onunload = finish;
        }
        }
}

function finishAPiCom(){}

function findScormApi(w) {
    if (w == null) {
        return findScormApi(this .top);
    }
    try {
        if (w.API) {
            // found it
            ScormApi = w.API;
            dbg("found Api SUCCESS");
            return;
        }
    }
    catch (e) {
        return;
    }
    
    for (var i = 0; i < w.length && ScormApi == null; i++) {
        findScormApi(w.frames[i]);
    }
    if (ScormApi == null && w.opener) {
        findScormApi(w.opener.top);
    }
}

function commit() {
    if (! ScormApi) {
        dbg("commit call can not be processed FAILED");
        return false;
    } else {
        dbg("saving data...");
        ScormApi.LMSCommit('');
        var Err = ScormApi.LMSGetLastError();
            dbg("LMSGetLastError() " + Err);
        dbg("commit to Lms SUCCESS");
    }
}

function disconnect() {
    if (! ScormApi) {
        dbg("disconnect call can not be processed FAILED");
        return false;
    } else {
        dbg("disconnecting from Lms...");
        ScormApi.LMSFinish('');
        var Err = ScormApi.LMSGetLastError();
        dbg("LMSGetLastError() " + Err);
        dbg("disconnected from Lms SUCCESS");
        
    }
}

function finish() {
    if (! ScormApi) {
        dbg("finish call can not be processed FAILED");
        return false;
    } else {
        //computing session time and calling setValue to set the session time
        timeSpend(StartTime);
        //OLAT LMS needs the comit-funtion for persiting data
        commit();
        //getValues for proving purpose
        var gVV;
        gVV = "cmi.core.total_time"
        getValue(gVV);
        var Err = ScormApi.LMSGetLastError();
        dbg("LMSGetLastError() " + Err);
        //diconnect
        disconnect('');
    }
}

function getValue(l) {
    var r;
    if (ScormApi) {
        r = ScormApi.LMSGetValue(l);
    }
    return r;
}

function setValue(l, r) {
    if (! ScormApi) return false;
    var result;
    result = ScormApi.LMSSetValue(l, r);
    return result;
}

function dbg(msg, va) {
    if (develMode) {
        if (va == undefined) console.log(msg); else console.log(msg + " " + va);
    }
}

function evaluateStatus() {
    if (ScormApi) {
     
   
        
        lesson_mode = getValue('cmi.core.lesson_mode');
        dbg("VAR lesson_mode = " + lesson_mode);
        lesson_status = getValue('cmi.core.lesson_status');
        dbg("VAR lesson_status = " + lesson_status);
        if (lesson_status == 'not attempted') {
        if (lesson_mode == 'normal') {
            setValue('cmi.core.lesson_status', lesson_mode = 'normal' ? 'completed' : 'browsed')
            //incomplete instead of browsed could be also be used here
            dbg("completed SUCCESS, lesson_status = ", lesson_status);
            var Err = ScormApi.LMSGetLastError();
            dbg("LMSGetLastError() " + Err);
        } else {
            setValue(
            'cmi.core.lesson_status',
            lesson_mode = 'browse' ? 'browsed' : 'browsed')
            //incomplete instead of browsed could be also be used here
            dbg("cold not set to completed FAILED", lesson_status);
            var Err = ScormApi.LMSGetLastError();
            dbg("LMSGetLastError() " + Err);
        }
       }
    }
}

function scormCommunication() {
    if (ScormApi) {
        dbg("init call can not be processed FAILED");
        return false;
    }
    dbg("Trying to connect to SCORM RTE...")
    findScormApi();
    if (! ScormApi) {
        dbg("SCORM RTE not found FAILED");
        dbg("Continuing without LMS support.");
    } else {
        dbg("SCORM RTE found SUCCESS")
        var rv = ScormApi.LMSInitialize('') .toString();
        if (rv != 'true' && rv != 't' && rv != '1') {
            dbg("SCORM RTE communication failed FAILED");
            ScormApi = null;
            dbg("VAR ScormApi = ", ScormApi);
        } else {
            dbg("SCORM RTE comminication established SUCCESS");
            //Alberto auskommentiert hier
            //window.onunload = finish;
        }
        lesson_mode = getValue('cmi.core.lesson_mode');
        dbg("VAR lesson_mode = " + lesson_mode);
        lesson_status = getValue('cmi.core.lesson_status');
        dbg("VAR lesson_status = " + lesson_status);
        //if (lesson_status == 'not attempted') {
        if (lesson_mode == 'normal') {
            setValue('cmi.core.lesson_status', lesson_mode = 'normal' ? 'completed' : 'browsed')
            //incomplete instead of browsed could be also be used here
            dbg("completed SUCCESS, lesson_status = ", lesson_status);
            var Err = ScormApi.LMSGetLastError();
            dbg("LMSGetLastError() " + Err);
        } else {
            setValue(
            'cmi.core.lesson_status',
            lesson_mode = 'browse' ? 'browsed' : 'browsed')
            //incomplete instead of browsed could be also be used here
            dbg("cold not set to completed FAILED", lesson_status);
            var Err = ScormApi.LMSGetLastError();
            dbg("LMSGetLastError() " + Err);
        }
        //}
    }
    //ILIAS hides the content as soon as the finish-call has been procesed
    window.onunload = finish;
}

function timeSpend(StartTime) {
    dbg("VAR StartTime= " + this .StartTime);
    var displayValue = new Array(4);
    var Date2 = new Date();
    var FinishTime = Date2.getTime();
    var TimeSpend = parseInt(FinishTime) - parseInt(this .StartTime);
    dbg("VAR TimeSpend= " + TimeSpend);
    var Temp = TimeSpend;
    dbg("VAR Temp= " + Temp);
    var Milis = parseInt(Temp) % 1000;
    var Value = Math.round(parseInt(Milis) /100);
    displayValue[3] = "." + Value;
    dbg("VAR Milis= " + Milis);
    dbg("VAR Value= " + Value);
    dbg("displayValue[3]= " + displayValue[3]);
    Temp = Math.floor(parseInt(Temp) /1000);
    dbg("VAR Temp= " + Temp);
    var Secs = parseInt(Temp) % 60;
    displayValue[2] = Secs;
    dbg("VAR Secs= " + Secs);
    dbg("displayValue[2]= " + displayValue[2]);
    Temp = Math.floor(parseInt(Temp) /60);
    dbg("VAR Temp= " + Temp);
    var Mins = parseInt(Temp) % 60;
    displayValue[1] = Mins;
    dbg("VAR Mins= " + Mins);
    dbg("displayValue[1]= " + displayValue[1]);
    Temp = Math.floor(parseInt(Temp) /60);
    dbg("VAR Temp= " + Temp);
    var Hours = parseInt(Temp) % 60;
    displayValue[0] = Hours;
    dbg("VAR Hours= " + Hours);
    dbg("displayValue[0]= " + displayValue[0]);
    Temp = Math.floor(parseInt(Temp) /60);
    dbg("VAR Temp= " + Temp);
    var resultTime = "";
    var i;
    for (i = parseInt(0);
    i < parseInt(displayValue.length);
    i++) {
        if (i < 2) {
            var Temp2 = parseInt(displayValue[i]);
            var Temp3;
            Temp2 < 10 ? Temp3 = "0" + displayValue[i] : Temp3 = displayValue[i];
            resultTime = "" + resultTime + Temp3 + ":";
            dbg("if resultTime= " + resultTime);
        } else {
            if (parseInt(i) == parseInt(2)) {
                var Temp2 = parseInt(displayValue[i]);
                var Temp3;
                Temp2 < 10 ? Temp3 = "0" + displayValue[i] : Temp3 = displayValue[i];
                resultTime = "" + resultTime + Temp3;
                dbg("else if resultTime= " + resultTime);
            }
            if (parseInt(i) == parseInt(3)) {
                var Temp2 = "";
                Temp2 = "" + displayValue[i];
                resultTime = "" + resultTime + Temp2;
                dbg("else if resultTime= " + resultTime);
            }
        }
    }
    var result;
    result = setValue('cmi.core.session_time', resultTime);
    dbg("cmi.core.session_time" + result);
    var Err = ScormApi.LMSGetLastError();
    dbg("LMSGetLastError() " + Err);
}



		  


		  
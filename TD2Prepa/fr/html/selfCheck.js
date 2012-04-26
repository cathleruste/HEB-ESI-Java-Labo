 
/* ----------------------

selfCheck.js    v. 1.3
@author: André Locher

Function library to implement self-check questions, which don't need to open
a new window or popup to show solution or feedback. The self-check library allows 
adding static questions without ANY logging functionality.

@features:
- question types:
  - single-choice
  - multiple-choice
  - fill-in-the-blanks
  
- question features
  - give a solution for every question type
  - give feedback for a single answer (only single and multiple-choice type)
  - add synonyms for gaps in fill-in-the-blanks questions
  - shuffle answers on pageload
  - uncheck all selections on pageload 

---------------------- */

/* remove if shuffle and uncheck of answers is not needed at pageload */
window.onload = initSelfCheck;


/* check questions of the type single/multipleChoice */
function checkChoice(itemName) {

var attempt = false;
var missingMC = 0;	
var wrongMC = 0;

var itemNode = document.getElementById (itemName);

if (itemNode) {
var inputs = itemNode.getElementsByTagName ('input');

	if (inputs) {

		for (var i = 0; i < inputs.length; ++i) {
			
			if ((inputs[i].type == 'radio' || inputs[i].type == 'checkbox') && inputs[i].name == itemName) {	
				var type = inputs[i].type;
				var value = inputs[i].value;
				var checked = inputs[i].checked;
				var itemAnswer = inputs[i].parentNode;
				var itemLabel = itemAnswer.getElementsByTagName ('div')[0];
				var itemHelp = itemAnswer.getElementsByTagName ('div')[1];
				
				spans = itemLabel.getElementsByTagName ('span');
				if (spans.length > 1) {
					var itemFeedback = spans.item(spans.length-1);
				} else {
					var itemFeedback = spans.item(0);
				} 
				
				if (checked) {
					attempt = true;
					if (value == 1) {
						itemHelp.style.visibility = "visible";
						itemAnswer.className = "itemAnswerCorrect";
						itemFeedback.className = "itemFeedbackCorrect";
						itemFeedback.innerHTML = "√";
					} else {
						wrongMC++;
						itemHelp.style.visibility = "visible";
						itemAnswer.className = "itemAnswerWrong";
						itemFeedback.className = "itemFeedbackWrong";
						itemFeedback.innerHTML = "X";
					}	
				// do nothing if (type == "checkbox" && !checked && value == 1)
				} else {
					if (value == 1) {
						missingMC++;
					}
					itemHelp.style.visibility = "hidden";
					itemAnswer.className = "itemAnswer";
					itemFeedback.className = "itemFeedback";
					itemFeedback.innerHTML = "";
				}
			}
		
	    }
	    
	    // show missing MC warning
	    if (missingMC > 0) {
	    	showMissingError(itemNode, "block");
	    } else if (missingMC < 1 && wrongMC < 1) {
	    	showMissingError(itemNode, "none");
	    	solutionChoice(itemName); // show solution of all correct
	    } else if (missingMC < 1 && wrongMC > 0) {
	    	showMissingError(itemNode, "none");
	    }
	    
	}

}

// enable solution button if something was checked
if (attempt) {
	showSolutionButton(itemName, "buttonSolution");
}
		
}

/* show solution of type single/multipleChoice */
function solutionChoice(itemName) {
var itemNode = document.getElementById (itemName);

if (itemNode) {
	
	showMissingError(itemNode, "none");
	showSolution(itemNode, "block");

	var inputs = itemNode.getElementsByTagName ('input');
	if (inputs) {
		for (var i = 0; i < inputs.length; ++i) {
			if ((inputs[i].type == 'radio' || inputs[i].type == 'checkbox') && inputs[i].name == itemName) {	
				var type = inputs[i].type;
				var value = inputs[i].value;
				var checked = inputs[i].checked;
				var itemAnswer = inputs[i].parentNode;
				var itemLabel = itemAnswer.getElementsByTagName ('div')[0];
				var itemHelp = itemAnswer.getElementsByTagName ('div')[1];
				
				spans = itemLabel.getElementsByTagName ('span');
				if (spans.length > 1) {
					var itemFeedback = spans.item(spans.length-1);
				} else {
					var itemFeedback = spans.item(0);
				}
	
				if (value == 1) {
					inputs[i].checked = true;
					itemHelp.style.visibility = "visible";
					itemAnswer.className = "itemAnswerCorrect";
					itemFeedback.className = "itemFeedbackCorrect";
					itemFeedback.innerHTML = "√";
				} else {
					inputs[i].checked = false;
					itemHelp.style.visibility = "hidden";
					itemAnswer.className = "itemAnswer";
					itemFeedback.className = "itemFeedback";
					itemFeedback.innerHTML = "";
				}	
			}
		
	    }
	}
}
}

/* check questions of the type fillInBlanks */
function checkGaps(itemName) {

var attempt = false;
var wrongGaps = 0;

var itemNode = document.getElementById (itemName);

if (itemNode) {
var inputs = itemNode.getElementsByTagName ('input');

	if (inputs) {
		for (var i = 0; i < inputs.length; ++i) {
			
			if (inputs[i].type == 'text') {	
				attempt = true;
				var correct = false;
				var value = inputs[i].value;
				var synonymsNode = inputs[i].nextSibling.nextSibling;
				var synonyms = synonymsNode.innerHTML.split(",");
				var itemLabel = inputs[i].parentNode;
				var itemAnswer = itemLabel.parentNode;
				var itemHelp = itemAnswer.getElementsByTagName ('div')[1];
				
				for (var j = 0; j < synonyms.length; ++j) {
					if (value == trim(synonyms[j])) {
						correct = true;
					}
				}

				if (correct) {
					//itemHelp.style.visibility = "visible";
					inputs[i].className = "GapCorrect";
					inputs[i].nextSibling.className = "itemFeedbackCorrect";
					inputs[i].nextSibling.innerHTML = "&nbsp;√";
				} else {
					wrongGaps++;
					//itemHelp.style.visibility = "visible";
					inputs[i].className = "GapWrong";
					inputs[i].nextSibling.className = "itemFeedbackWrong";
					inputs[i].nextSibling.innerHTML = "&nbsp;X";
				}	
			}
	    }
	    
	    // show solution if all correct
	    if (wrongGaps < 1) {
	    	solutionGaps(itemName);
	    }
	}

}

// enable solution button if something was checked
if (attempt) {
	showSolutionButton(itemName, "buttonSolution");
}

}

/* show solution of type fillInBlank */
function solutionGaps(itemName) {
var itemNode = document.getElementById (itemName);
	
if (itemNode) {
	
	showSolution(itemNode, "block");
	
	var inputs = itemNode.getElementsByTagName ('input');
	if (inputs) {
		for (var i = 0; i < inputs.length; ++i) {
			var synonymsNode = inputs[i].nextSibling.nextSibling;
			var synonyms = synonymsNode.innerHTML.split(",");
			var itemLabel = inputs[i].parentNode;
			var itemAnswer = itemLabel.parentNode;
			var itemHelp = itemAnswer.getElementsByTagName ('div')[1];

			inputs[i].value = trim(synonyms[0]);
			//itemHelp.style.visibility = "visible";
			inputs[i].className = "GapCorrect";
			inputs[i].nextSibling.className = "itemFeedbackCorrect";
			inputs[i].nextSibling.innerHTML = "&nbsp;√";
		}
	}
}
}



/* Missing Error Message */
function showMissingError(itemNode, status) {
var missingMCdiv = itemNode.getElementsByTagName ('div');
	if (missingMCdiv) {
		for (var i = 0; i < missingMCdiv.length; ++i) {
			if (missingMCdiv[i].className=="missingMC") {
				missingMCdiv[i].style.display = status;
			}
		}
	}
}


/* Solution Button */
function showSolutionButton(itemName, status) {
	var buttonSolution = document.getElementById (itemName + "_solution");
	if (buttonSolution) {
		buttonSolution.disabled = false;
		buttonSolution.className = status;
	}
}

/* Solution Message */
function showSolution(itemNode, status) {
	var divs = itemNode.getElementsByTagName ('div');
	if (divs) {
		for (var i = 0; i < divs.length; ++i) {
			if (divs[i].className == "itemSolution") {
				if (divs[i].style.display == "block") {
					// do nothing
				} else {
					divs[i].style.display = status;
				}
			}
		}
	}
}


/* shuffle answers where wanted */
function shuffleAnswers() {
var allItems = document.getElementsByTagName('div');
	if (allItems) {
		for (var j = 0; j < allItems.length; ++j) {	
			if ((allItems[j].className == 'singleChoiceShuffle') || (allItems[j].className == 'multipleChoiceShuffle') || (allItems[j].className == 'fillInBlanksShuffle')) {
				var itemAnswers = allItems[j].getElementsByTagName('div');
				var answers = new Array();
				if (itemAnswers) {
					for (var i = 0; i < itemAnswers.length; ++i) {	
						if (itemAnswers[i].className == 'itemAnswer') {
							answers.push(itemAnswers[i]);
						} else if (itemAnswers[i].className == 'itemTitle') {
							var itemTitle = itemAnswers[i];
						} else if (itemAnswers[i].className == 'missingMC') {
							var missingMC = itemAnswers[i];
						} else if (itemAnswers[i].className == 'itemSolution') {
							var itemSolution = itemAnswers[i];
						} else if (itemAnswers[i].className == 'itemCheck') {
							var itemCheck = itemAnswers[i];
						} 
					}
				}
			// randomize nodes and insert into DOM, removing existing nodes
			fisherYates(answers);
			for (var h = 0; h < answers.length; ++h) {
				allItems[j].appendChild(answers[h]);
			}
			
			if (missingMC) {
				allItems[j].appendChild(missingMC);
			}
			if (itemSolution) {
				allItems[j].appendChild(itemSolution);
			}
			if (itemCheck) {
				allItems[j].appendChild(itemCheck);
			}
			
			}
			itemSolution = null;
			itemCheck = null;
		}
	}
}

/* uncheck all form elements and remove text */
function uncheckElements() {
var allInputs = document.getElementsByTagName('input');
	if (allInputs) {
		for (var i = 0; i < allInputs.length; ++i) {	
			if (allInputs[i].type == 'radio' || allInputs[i].type == 'checkbox') {
		  		allInputs[i].checked = false;
			} else if (allInputs[i].type == 'text') {
				allInputs[i].value = "";
			}
		}
	}
}

/* function to init all selfCheck elements at pageload */
function initSelfCheck() {
	uncheckElements();
	shuffleAnswers();
}


/* array shuffle */
function fisherYates ( myArray ) {
  var i = myArray.length;
  if ( i == 0 ) return false;
  while ( --i ) {
     var j = Math.floor( Math.random() * ( i + 1 ) );
     var tempi = myArray[i];
     var tempj = myArray[j];
     myArray[i] = tempj;
     myArray[j] = tempi;
   }
}

/* remove multiple, leading or trailing spaces */
function trim(s) {
	s = s.replace(/(^\s*)|(\s*$)/gi,"");
	s = s.replace(/[ ]{2,}/gi," ");
	s = s.replace(/\n /,"\n");
	return s;
}
		  
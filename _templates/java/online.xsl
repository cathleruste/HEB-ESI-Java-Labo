<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:elml="http://www.elml.ch" xmlns="http://www.w3.org/1999/xhtml" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
	<xsl:import href="../../../core/presentation/online/elml.xsl"/>
	<!-- ***** Parameter definitions  *****-->
	<!--The name of this layout (=folder name of template folder!) -->
	<xsl:param name="layout" select="'java'"/>
	<!--If you would like to have a navigation, set this to "yes" else (eg. for content package CP format) to "no" -->
	<!--<xsl:param name="use_navigation" select="'no'"/>-->
	<!-- ***** Template definitions  ***** -->
	<xsl:template name="elml:LayoutBody">
		<body>
			<xsl:if test="$manifest_type='scorm'">
				<xsl:attribute name="onunload">
					<xsl:value-of>finish()</xsl:value-of>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="elml:LayoutBodySkiplinks"/>
			<xsl:call-template name="elml:navigation"/>
			<xsl:call-template name="arrows"/>
			<a name="top"/>
			<xsl:if test="name(.)='lesson' and $use_navigation='no'">
				<xsl:call-template name="logo"/>
			</xsl:if>
			<xsl:call-template name="elml:LayoutBodyContent"/>
			<hr/>
			<xsl:call-template name="arrows"/>
			<xsl:call-template name="elml:footer"/>
		</body>
	</xsl:template>
	
	<xsl:template name="arrows">
		<xsl:param name="prev">
			<xsl:call-template name="elml:prev_file"/>
		</xsl:param>
		<xsl:param name="next">
			<xsl:call-template name="elml:next_file"/>
		</xsl:param>
		<xsl:if test="$use_navigation='yes'">
			<div class="navigation_arrows">
				<xsl:choose>
					<xsl:when test="$prev='none.html'">
						<img src="../../../_templates/{$layout}/navigation/back_off.gif" height="24" width="24" alt="No previous page available" border="0"/>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$prev}">
							<img src="../../../_templates/{$layout}/navigation/back.gif" height="24" width="24" alt="Go to previous page" border="0"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:choose>
					<xsl:when test="$next='none.html'">
						<img src="../../../_templates/{$layout}/navigation/next_off.gif" height="24" width="24" alt="No following page available" border="0"/>
					</xsl:when>
					<xsl:otherwise>
						<a href="{$next}">
							<img src="../../../_templates/{$layout}/navigation/next.gif" height="24" width="24" alt="Go to next page" border="0"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>

	<xsl:template name="logo">
		<div id="logo"><img src="../../../_templates/{$layout}/icons/logo-esi.jpg" alt="LOGO ESI"/></div>
		<div id="ecole">Haute École de Bruxelles - École Supérieure d'Informatique</div>
		<div id="cours">
				<xsl:value-of select="/elml:lesson/elml:metadata/elml:organisation/@module"/> - 
				<xsl:value-of select="/elml:lesson/elml:metadata/elml:organisation/@level"/>
		</div>
		<div id="formation">Bachelor en Informatique</div>
		<div id="annee">
			<xsl:value-of select="/elml:lesson/elml:metadata/elml:lessonInfo/elml:lifecycle/elml:version"/>
		</div>
	</xsl:template>
	
	<!-- Pourquoi avoir modifier le traitement de paragraph ? -->
	<xsl:template match="elml:paragraph">
		<xsl:param name="display">
			<xsl:call-template name="elml:display"/>
		</xsl:param>
		<xsl:if test="$display='yes'">
			<xsl:if test="@title">
				<h4>
					<xsl:value-of select="@title"/>
					<xsl:if test="@icon and not($layout='none')">
						<img src="../../../_templates/{$layout}/icons/{@icon}.{$icon_filetype}" title="{@icon}" alt="{@icon}" class="icon"/>
					</xsl:if>
				</h4>
			</xsl:if>
			<p>
			<xsl:call-template name="elml:CSS_Class"/>
			<xsl:if test="@title">
				<xsl:attribute name="title">
					<xsl:value-of select="@title"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:call-template name="elml:Label"/>
			<xsl:apply-templates/>
			</p>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="elml:formatted[@style='input']">
		<span class="input"><xsl:apply-templates/></span>
	</xsl:template>

	<xsl:template match="elml:formatted[@style='java']">
		<code><xsl:apply-templates/></code>
	</xsl:template>
  
    <xsl:template match="elml:paragraph[@cssClass='java'] | elml:paragraph[@cssClass='javawithblanks']">
		<xsl:param name="display">
			<xsl:call-template name="elml:display"/>
		</xsl:param>
		<xsl:if test="$display='yes'">
			<pre><xsl:apply-templates/></pre>
		</xsl:if>
    </xsl:template>

    <xsl:template match="elml:paragraph[@cssClass='code']">
		<xsl:param name="display">
			<xsl:call-template name="elml:display"/>
		</xsl:param>
		<xsl:if test="$display='yes'">
			<pre><xsl:apply-templates/></pre>
		</xsl:if>
    </xsl:template>

    <xsl:template match="elml:paragraph[@cssClass='output']">
		<xsl:param name="display">
			<xsl:call-template name="elml:display"/>
		</xsl:param>
		<xsl:if test="$display='yes'">
			<pre><xsl:apply-templates/></pre>
		</xsl:if>
    </xsl:template>

	<!-- Si titre dans popup ne pas metre le texte par déaut en plus)-->
	<xsl:template match="elml:popup">
		<xsl:param name="display">
			<xsl:call-template name="elml:display"/>
		</xsl:param>
		<xsl:variable name="varname">
			<xsl:text>solution</xsl:text>
			<xsl:value-of select="generate-id()"/>
		</xsl:variable>
		<xsl:if test="$display='yes'">
			<p id="{$varname}" class="popupTitle" style="cursor: pointer;">
				<xsl:if test="not($layout='firedocs')">
					<xsl:attribute name="onclick">
						<xsl:text>onBlock('</xsl:text>
						<xsl:value-of select="$varname"/>
						<xsl:text>')</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<xsl:call-template name="elml:Label"/>
				<xsl:if test="@icon and not($layout='none')">
					<xsl:call-template name="Icon">
						<xsl:with-param name="icon" select="@icon"/>
					</xsl:call-template>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="@title and not($name_solutiontext='')">
						<xsl:text>Cliquez pour voir </xsl:text><xsl:value-of select="@title"/>
					</xsl:when>
					<xsl:when test="@title and $name_solutiontext=''">
						<xsl:value-of select="@title"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="$name_solutiontext"/>
					</xsl:otherwise>
				</xsl:choose>
			</p>
			<div id="{$varname}text">
				<xsl:attribute name="style">
					<xsl:choose>
						<xsl:when test="$layout='firedocs'">
							<xsl:text>cursor: pointer;</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>display: none; cursor: pointer;</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
				<xsl:call-template name="elml:CSS_Class"/>
				<xsl:if test="@title">
					<xsl:attribute name="title">
						<xsl:value-of select="@title"/>
					</xsl:attribute>
				</xsl:if>
				<xsl:if test="not($layout='firedocs')">
					<xsl:attribute name="onclick">
						<xsl:text>off('</xsl:text>
						<xsl:value-of select="$varname"/>
						<xsl:text>')</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<xsl:choose>
					<xsl:when test="text()">
						<p>
							<xsl:apply-templates/>
						</p>
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates/>
					</xsl:otherwise>
				</xsl:choose>
			</div>
		</xsl:if>
	</xsl:template>
	
	<!-- Gesiton de la taille du trou
	+ Ajout de l'attribut 'separator' donnant le caractère servant de séparateur dans les réponses.
	Permet de gérer les cas où la ',' est dans la réponse.
	Javascript adapté en conséquence.
	-->
	<xsl:template match="elml:gap">
		<xsl:param name="selfCheckLabel"/>
		<xsl:param name="gap_stringlength">
			<xsl:choose>
				<xsl:when test="string-length(.)&lt;2">12</xsl:when>
				<xsl:when test="string-length(.)&lt;4">25</xsl:when>
				<xsl:when test="string-length(.)&lt;8">50</xsl:when>
				<xsl:when test="string-length(.)&lt;16">100</xsl:when>
				<xsl:when test="string-length(.)&lt;32">160</xsl:when>
				<xsl:when test="string-length(.)&lt;64">300</xsl:when>
				<xsl:otherwise>400</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<xsl:param name="separator">
			<xsl:choose>
				<xsl:when test="@separator"><xsl:value-of select="@separator"/></xsl:when>
				<xsl:otherwise>,</xsl:otherwise>
			</xsl:choose>
		</xsl:param>
		<input type="text" value="" class="itemText" id="{$selfCheckLabel}_{generate-id(.)}" style="width:{$gap_stringlength}px"/>
		<xsl:text> </xsl:text><span class="gapText">
		<xsl:value-of select="$separator"/>
		<xsl:value-of select="." disable-output-escaping="yes"/>
		<xsl:if test="@answers!=''">
			<xsl:value-of select="$separator"/>
		</xsl:if>
		<xsl:value-of select="@answers"/>
		</span>
	</xsl:template>

	<!-- Les < et > ne passent pas bien dans les gap -->
    <xsl:template name="elml:LayoutSelfCheckScriptCode">
        <xsl:text disable-output-escaping="yes"> <![CDATA[
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
				var separator = synonymsNode.innerHTML.charAt(0);
				var synonyms = synonymsNode.innerHTML.split(separator);
				synonyms.shift();
				var itemLabel = inputs[i].parentNode;
				var itemAnswer = itemLabel.parentNode;
				var itemHelp = itemAnswer.getElementsByTagName ('div')[1];
				
				for (var j = 0; j < synonyms.length; ++j) {
					if (value == decodeMCD(synonyms[j])) {
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
			var separator = synonymsNode.innerHTML.charAt(0);
			var synonyms = synonymsNode.innerHTML.split(separator);
			synonyms.shift();
			var itemLabel = inputs[i].parentNode;
			var itemAnswer = itemLabel.parentNode;
			var itemHelp = itemAnswer.getElementsByTagName ('div')[1];

			inputs[i].value = decodeMCD(synonyms[0]);
			//itemHelp.style.visibility = "visible";
			inputs[i].className = "GapCorrect";
			inputs[i].nextSibling.className = "itemFeedbackCorrect";
			inputs[i].nextSibling.innerHTML = "&nbsp;√";
		}
	}
}
}

/* Ajout MCD pour traiter correctement <, > et & */
function decodeMCD(chaine) {
	var answer = trim(chaine);
	answer = answer.replace(/&lt;/g,"<");
	answer = answer.replace(/&gt;/g,">");
	answer = answer.replace(/&amp;/g,"&");
	return answer;
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
		 ]]> </xsl:text>
    </xsl:template>

	<!-- Metadat -->
    <xsl:template match="elml:organisation">
            <ul>
                <li><xsl:text>Niveau : </xsl:text><xsl:value-of select="@level"/></li>
                <li><xsl:text>Module : </xsl:text><xsl:value-of select="@module"/></li>
                <li><xsl:text>Leçon  : </xsl:text><xsl:value-of select="/elml:lesson/@title"/></li>
            </ul>
	</xsl:template>
	<xsl:template match="elml:prerequisites"/>
	<xsl:template match="elml:preReqItem"/>
	<xsl:template match="elml:keywords"/>
    <xsl:template match="elml:technical"/>
    <xsl:template match="elml:technicalRequirement"/>
	<xsl:template match="elml:lessonInfo">
		<xsl:apply-templates/>
	</xsl:template>
    <xsl:template match="elml:educational"/>
    <xsl:template match="elml:lifecycle">
            <ul>
				<li>Version : <xsl:value-of select="elml:version"/></li>
				<li>Auteurs : <xsl:apply-templates select="elml:contribute"/></li>
            </ul>
    </xsl:template>
    <xsl:template match="elml:contribute">
        <xsl:for-each select="elml:person">
			<xsl:value-of select="@name"/><xsl:text>  </xsl:text>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="elml:newLine">
        <xsl:choose>
            <xsl:when test="($html_version='1.1' or $html_version='5' or $css_framework='yaml') and @space='long'">
                <br/>
                <br/>
            </xsl:when>
            <xsl:when test="$html_version='1.1' or $html_version='5' or $css_framework='yaml'">
                <br/>
            </xsl:when>
            <xsl:when test="@space='long'">
                <br/>
                <br/>
            </xsl:when>
            <xsl:otherwise>
                <br/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

	<!-- cf issue #28 : par défaut appostrophe changée en " car mis dans une chaine '...' -->
	<!-- j'ai changé en \' -->
    <xsl:template name="elml:tooltipAttribute">
        <xsl:param name="termid"/>
        <xsl:param name="termdefinition">
            <xsl:apply-templates select="/elml:lesson/elml:glossary/elml:definition[@term=$termid]"/>
        </xsl:param>
        <xsl:variable name="apos">&#39;</xsl:variable>
        <xsl:attribute name="onmouseover">
            <xsl:if test="not(@feedback) and $glossaryMousoverWithHTML='yes'">
                <xsl:text>TagTo</xsl:text>
            </xsl:if>
            <xsl:text>Tip('</xsl:text>
            <xsl:choose>
                <xsl:when test="@feedback">
                    <xsl:value-of select="translate(translate(@feedback,&quot;&#xA;&quot;,&quot;&quot;),&quot;&apos;&quot;, &quot;&#146;&quot;)"/>
                    <xsl:text>')</xsl:text>
                </xsl:when>
                <xsl:when test="$glossaryMousoverWithHTML='yes'">
                    <xsl:text>term</xsl:text>
                    <xsl:value-of select="generate-id(/elml:lesson/elml:glossary/elml:definition[@term=$termid])"/>
                    <xsl:text>', TITLE, '</xsl:text>
                    <xsl:value-of select="/elml:lesson/elml:glossary/elml:definition[@term=$termid]/@term"/>
                    <xsl:text>')</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="translate(translate(/elml:lesson/elml:glossary/elml:definition[@term=$termid],&quot;&#xA;&quot;,&quot;&quot;),&quot;&apos;&quot;, &quot;&quot;&quot;&quot;)"/>
                    <xsl:text>', TITLE, '</xsl:text>
                    <xsl:value-of select="/elml:lesson/elml:glossary/elml:definition[@term=$termid]/@term"/>
                    <xsl:text>')</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="onmouseout">
            <xsl:text>UnTip()</xsl:text>
        </xsl:attribute>
    </xsl:template>

</xsl:stylesheet>

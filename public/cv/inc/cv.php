<?php

// Connects to the database
function db_connect() {
   $MYSQL_DB = "ockleor_martincv1";
   $MYSQL_HOST = "localhost";
   $MYSQL_USER = "ockleor_martincv";
   $MYSQL_PASS = "Bags0$";

   @mysql_connect ($MYSQL_HOST, $MYSQL_USER, $MYSQL_PASS)
      OR die ("Connection Error to Server");
   @mysql_select_db ($MYSQL_DB)
      OR die ("Connection Error to Database");

   return;
}


// Performs a database query
function db_query($query) {
	$result = mysql_query($query) 
		or die ("Could not perform MySQL query \"" . $query . "\" because: " . 
			mysql_error());
	return $result;
}

// Output the top
function start($outputstyle, $title) {
	global $handle;
	global $type;
	
	if($outputstyle == "html") {
		$style = "cv";
		if($_REQUEST['style']) {
			$style = $_REQUEST['style'];
		}
	}

	if($outputstyle == "pdf") {
		$filename = "data/cv-" . $type . ".tex";
		print system("rm -f " . $filename);
		$handle = fopen($filename, 'a');
	}
	
	output($outputstyle, array(
		"html" => "<html>\n" .
			"<head>\n" .
			"<meta http-equiv=\"Content-Type\" " .
			"content=\"text/html;charset=ISO-8859-1\" >\n" .
			"<title>" . $title . "</title>\n" .
			"<link REL=\"stylesheet\" TYPE=\"text/css\" href=\"" . 
			$style . ".css\">\n" .
			"<script language=\"javascript\">\n" .
			"var ie4 = false;\n" .
			"if(document.all) { ie4 = true; }\n" .
			"function getObject(id) { \n" .
			"   if (ie4) { return document.all[id]; }\n" .
			"   else { return document.getElementById(id); }\n" .
			"}\n\n" .
			"function toggle(link, divId) { \n" .
			"   var lText = link.innerHTML; var d = getObject(divId);\n" .
			"   if (lText == '+') { \n" .
			"      link.innerHTML = '&#150;'; d.style.display = ''; \n" .
			"   } else { link.innerHTML = '+'; d.style.display = 'none'; } \n" .
			"}\n" .
			"</script>\n" .

			"</head>\n" .
			"<body>\n" .
			"<h1>" . $title . "</h1>\n",
		"latex" => "% <!-- This makes it look pretty in a browser --><pre>\n" .
			"\\documentclass[a4paper,english]{cv}\n" .
			"\\usepackage[latin1]{inputenc}\n" .
			"\\usepackage{a4wide}\n" .
			"\\pagestyle{empty}\n" .
			"\\usepackage{graphicx}\n" .
			"\\usepackage{longtable}\n" .
			"\\makeatletter\n" .
			"\\newcommand{\\HS}{\\hspace{0.5cm}}\n" .
			"\\date{}\n" .
			"\\newcommand{\\B}[1]{%\n" .
			"\\makebox[1cm][l]{\\small{#1:}}}\n" .
			"\\newcommand{\\VT}{\\vspace{2mm}}\n" .
			"\\renewcommand{\\topicmargin}{7em}\n" .
			"\\usepackage{babel}\n" .
			"\\makeatother\n" .
			"\\begin{document}\n" .
			"\\title{Curriculum Vitae}\n" .
			"\\maketitle\n"));

	return;
}

// Output the HTML bottom
function do_end($outputstyle) {
	global $type;

	output($outputstyle, array(
		"html" => "</body>\n" .
			"</html>\n",
		"latex" => "\\end{document}\n" .
			"%</pre><!-- This makes it look pretty in a browser -->\n"));

	if($outputstyle == "pdf") {
		exec("cd data/ && " .
			"/usr/bin/pdflatex cv-" . $type . " && " .
			"/usr/bin/pdflatex cv-" . $type, $output, $return);

		if($return > 0) {
			print "<pre>\n\n";
			foreach ($output as $line) {
				print $line . "\n";
			}
			print "</pre>";
		} else {
			header("Location: http://www.martinstrauss.id.au/cv/data/cv-" . 
				$type . ".pdf");
		}
	}

	return;
}

// PERSONAL INFO
function do_personal_info($outputstyle) {
	$result = db_query("SELECT * FROM personal_info");
	$row = mysql_fetch_array($result, MYSQL_ASSOC);
	output($outputstyle, array(
		"html" => "<table width=100%><tr><td><br/>\n" .
			"<strong>Name:</strong> " . $row['Name'] . "<br/>\n" .
			"<strong>Address:</strong><br/>\n" . 
			str_replace("\n", "<br/>\n", $row['Address']) . "<br/>\n" .
			"<strong>Telephone:</strong><br/>\n" . 
			str_replace("\n", "<br/>\n", $row['Telephone']) . "<br/>\n" .
			"<strong>Email:</strong> " . $row['Email'] . "<br/>\n" .
			"<strong>Birth:</strong> " . $row['Birth'] . "<br/>\n" .
			"<strong>Citizenship:</strong> " . $row['Citizenship'] . 
			"<br/>\n",
		"latex" => "\\thispagestyle{empty}\\centerline{\\fbox{" .
			"\\begin{minipage}[c]{0.50\\columnwidth}%\n" .
			"\\begin{center}\\hfill{}\\hfill{}\\begin{tabular}{p{2.1cm}p{4cm}}\n" .
			"Name:&\n" . $row['Name'] . "\\\\\n" .
			//"Address:&\n\\parbox[t]{4cm}{29 Lakeside Boulevarde\\\\\n" .
			//"Lara, VIC, 3212\\\\\nAustralia\\VT{}}\\\\\n" .
			"Address:&\n\\parbox[t]{4cm}{" . 
			str_replace("\n", "\\\\\n", $row['Address']) . "\\VT{}}\\\\\n" .
			"Telephone:&\n\\parbox[t]{4cm}{" . 
			str_replace("\n", "\\\\\n", $row['Telephone']) . 
			"\\VT{}}\\\\\n" .
			"E-mail:& ". $row['Email'] . "\\\\\n" .
			"Birth:& ". $row['Birth'] . "\\\\\n" .
			"Citizenship:& " . $row['Citizenship'] . "\\\\\n"));

	output($outputstyle, array(
		"html" => "<br/></td><td>" .
			"<img src=data/Strauss_Martin.jpg height=100% /></td></tr></table>\n",
		"latex" => "\\end{tabular}\\hfill{}\\end{center}\\end{minipage}%\n" .
			"\\begin{minipage}[c]{0.50\\columnwidth}%\n" .
			"~\\hfill{}\\includegraphics[%\n" .
			"  width=0.50\\columnwidth,\n" .
			"  keepaspectratio]{Strauss_Martin.jpg}\\hfill{}~\\end{minipage}%\n" .
			"}}\n"));


	return;
}
// END PERSONAL INFO

// PROFESSIONAL INTERESTS
function do_professional_interests($outputstyle) {
	output($outputstyle, array(
		"html" => "<h2>\n" .
			"[<a id='profint_link' href=\"javascript: void();\" " .
			"onclick = \"toggle(this, 'profint');\" >" .
			"-</a>]\n" .
			"Professional Interests" .
			"\n</h2>\n",
		"latex" => "\\section{" .
			"Professional Interests" .
			"}\n\n"));
	$result = db_query("SELECT * FROM professional_interests");
	output($outputstyle, array(
		"html" => "<div id='profint'>", "latex" => ""));
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
		output($outputstyle, array(
			"html" => "<p>" . $row['Description'] . "</p>\n",
			"latex" => $row['Description']));
	}
	output($outputstyle, array(
		"html" => "</div>\n", "latex" => ""));
	//print("<script language=\"javascript\">\n");
	//print("toggle(getObject('profint_link'), 'profint');\n");
	//print("</script>\n");
	return;
}
// END PROFESSIONAL INTERESTS

// EDUCATION
function do_education($outputstyle, $length, $awards, $positions) {
	output($outputstyle, array(
		"html" => "<h2>Education</h2>\n",
		"latex" => "\\section{Education}\n\n\\begin{topic}\n"));
	$result = db_query("SELECT * FROM education ORDER BY ID DESC");
	$counter = 0;
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
		$counter++;
		output($outputstyle . $length, array(
			"htmllong" => "<h3>" .
				"[<a id='edu" . $counter . "_link' href=\"javascript: void();\" " .
				"onclick = \"toggle(this, 'edu" . $counter ."');\" >" .
				"-</a>]\n" .
				$row['Date'] .
				": " .
				$row['Title'] .
				"\n</h3>\n" .
				"<h4>" . $row['Subtitle'] . "</h4>\n<div id='edu" . $counter . "'>",
			"htmlshort" => "<h3>" .
				$row['Date'] .
				": " .
				$row['Title'] .
				"\n</h3>\n" .
				"<h4>" . $row['Subtitle'] . "</h4>\n",
			"latexlong" => "\\item [" .
				$row['Date'] .
				"]\\textbf{" .
				$row['Title'] .
				"} " .
				$row['Subtitle'],
			"latexshort" => "\\item [" .
				$row['Date'] .
				"]\\textbf{" .
				$row['Title'] .
				"} " .
				$row['Subtitle']));

		if($row['Description']) {
			output($outputstyle . $length, array(
				"htmllong" => "<p>" . $row['Description'],
				"latexlong" => "\n\n" . $row['Description']));
			if($row['Publications_Link'] > 0) {
				output($outputstyle . $length, array(
					"htmllong" => "  See Publications, #" . 
						$row['Publications_Link'] . ".",
					"latexlong" => "(see Publications below, \\emph{{[}" .
						$row['Publications_Link'] . "{]}})"));
			}
			output($outputstyle . $length, array(
				"htmllong" => "</p>\n",
				"latexlong" => "\n\n"));
		}
		if($awards or $positions) {
			$html = "<ul>";
			$latex = "\\begin{itemize}\n";
			$found = 0;
		}
		// AWARDS
		if($awards) {
			$result1 = db_query(
				"SELECT * FROM awards WHERE Education_Link = " . $row['ID'] . 
				" ORDER BY DateIndex DESC");
			while($row1 = mysql_fetch_array($result1, MYSQL_ASSOC)){
				$html .= "<li>" . $row1['Description'] . "</li>\n";
				$latex .= "\\item " . $row1['Description'] . "\n";
				$found++;
			}
		}
		// END AWARDS
		
		// POSITIONS
		if($positions) {
			$result1 = db_query(
				"SELECT * FROM other_experience WHERE Education_Link = " . 
				$row['ID']);
			while($row1 = mysql_fetch_array($result1, MYSQL_ASSOC)){
				$html .= "<li>" . $row1['Title'] . ", " . $row1['Date'] . "</li>\n";
				$latex .= "\\item " . $row1['Title'] . ", " . $row1['Date'] . "\n";
				$found++;
			}
		}
		// END POSITIONS
		if($awards or $positions) {
			$html .= "</ul>\n";
			$latex .= "\\end{itemize}\n";
			if($found) {
				output($outputstyle . $length, array(
					"htmllong" => $html,
					"latexlong" => $latex));
			}
		}
		output($outputstyle . $length, array(
			"htmllong" => "</div>\n<script language=\"javascript\">\n" .
				"toggle(getObject('edu" . $counter ."_link'), 'edu" . 
				$counter ."');\n</script>\n",
			"latexlong" => ""));
	}
	output($outputstyle, array(
		"html" => "",
		"latex" => "\end{topic}\n\n"));
	return;
}
// END EDUCATION

// OTHER TRAINING
function do_other_training($outputstyle, $length) {
	output($outputstyle, array(
		"html" => "<h2>Other Training</h2>\n",
		"latex" => "\\section{Other Training}\n\n\\begin{topic}\n"));
	$result = db_query("SELECT * FROM other_training ORDER BY DateIndex DESC");
	$counter = 0;
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
		$counter++;
		output($outputstyle . $length, array(
			"htmllong" => "<h3>" .
				"[<a id='trn" . $counter . "_link' href=\"javascript: void();\" " .
				"onclick = \"toggle(this, 'trn" . $counter ."');\" >" .
				"-</a>]\n" .
				$row['Date'] . ": " . $row['Title'] . "\n" .
				"</h3>\n" .
				"<div id='trn" . $counter . "'><p>" . $row['Description'] .
				"</div>\n" .
				"<script language=\"javascript\">\n" .
				"toggle(getObject('trn" . $counter ."_link'), 'trn" . 
				$counter ."');\n" .
				"</script>\n",
			"htmlshort" => "<h3>" .
				$row['Date'] . ": " . $row['Title'] . "\n" .
				"</h3>\n",
			"latexlong" => "\\item [" . $row['Date'] . "] " . $row['Title'] . 
				"\n\n" .	$row['Description'] . "\n\n",
			"latexshort" => "\\item [" . $row['Date'] . "] " . $row['Title'] . 
				"\n\n"));
	}
	output($outputstyle, array(
		"html" => "",
		"latex" => "\\end{topic}\n"));
	return;
}
// END OTHER TRAINING

// WORK EXPERIENCE
function do_work_experience($outputstyle, $length) {
	output($outputstyle, array(
		"html" => "<h2>Employment</h2>\n",
		"latex" => "\\section{Employment}\n\n\\begin{topic}\n"));
	$result = db_query("SELECT * FROM work_experience ORDER BY DateIndex DESC");
	$counter = 0;
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
		$counter++;
		output($outputstyle . $length, array(
			"htmllong" => "<h3>" .
				"[<a id='emp" . $counter . "_link' href=\"javascript: void();\" " .
				"onclick = \"toggle(this, 'emp" . $counter ."');\" >" .
				"-</a>]\n" .
				$row['Date'] . ": " . $row['Title'] .
				"\n</h3>\n" .
				"<div id='emp" . $counter . "'>" .
				"<h4>" . $row['Subtitle'] . "</h4>\n" .
				"<p>" . $row['Description'] .
				"</div>\n" .
				"<script language=\"javascript\">\n" .
				"toggle(getObject('emp" . $counter ."_link'), 'emp" . 
				$counter ."');\n" .
				"</script>\n",
			"htmlshort" => "<h3>" .
				$row['Date'] . ": " . $row['Title'] .
				"\n</h3>\n" .
				"<h4>" . $row['Subtitle'] . "</h4>\n",
			"latexlong" => "\\item [" .	$row['Date'] . "] " .
				"\\textbf{" . $row['Title'] . "}  " . $row['Subtitle'] . "\n\n" .
				$row['Description'] . "\n\n",
			"latexshort" => "\\item [" .	$row['Date'] . "] " .
				"\\textbf{" . $row['Title'] . "}  " . $row['Subtitle'] . "\n\n"));
	}
	output($outputstyle, array(
		"html" => "",
		"latex" => "\\end{topic}\n\n"));
	
	return;
}
// END WORK EXPERIENCE

// OTHER EXPERIENCE
function do_other_experience($outputstyle, $length) {
	output($outputstyle, array(
		"html" => "<h2>Other Positions Held</h2>\n",
		"latex" => "\\section{Other positions held}\n\n\\begin{topic}\n"));
	$result = db_query("SELECT * FROM other_experience");
	$counter = 0;
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
		$counter++;
		output($outputstyle . $length, array(
			"htmllong" => "<h3>" .
				"[<a id='exp" . $counter . "_link' href=\"javascript: void();\" " .
				"onclick = \"toggle(this, 'exp" . $counter ."');\" >" .
				"-</a>]\n" .
				$row['Date'] . ": " . $row['Title'] . "\n</h3>\n" .
				"<div id='exp" . $counter . "'><p>" .
				$row['Description'] .
				"</div>\n" .
				"<script language=\"javascript\">\n" .
				"toggle(getObject('exp" . $counter ."_link'), 'exp" . 
				$counter ."');\n" .
				"</script>\n",
			"htmlshort" => "<h3>" .
				$row['Date'] . ": " . $row['Title'] . "\n</h3>\n",
			"latexlong" => "\\item [" . $row['Date'] . "] " .
				"\\textbf{" . $row['Title'] . "}\n\n" .
				$row['Description'] .
				"\n\n",
			"latexshort" => "\\item [" . $row['Date'] . "] " .
				"\\textbf{" . $row['Title'] . "}\n\n"));
	}
	output($outputstyle, array(
		"html" => "",
		"latex" => "\\end{topic}\n\n"));
	return;
}
// END OTHER EXPERIENCE

// PUBLICATIONS
function do_publications($outputstyle) {
	output($outputstyle, array(
		"html" => "<h2>" .
			"[<a id='publ_link' href=\"javascript: void();\" " .
			"onclick = \"toggle(this, 'publ');\" >" .
			"-</a>]\n" .
			"Publications\n" .
			"</h2>\n",
		"latex" => "\\section{Publications}\n\n"));

	$result = db_query("SELECT * FROM publications");
	output($outputstyle, array(
		"html" => "<div id='publ'><ol>\n",
		"latex" => "\\begin{topic}\n"));
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
		output($outputstyle, array(
			"html" => "<li value=" . $row['ID'] . ">" . $row['Authors'] . 
				", <strong>" . $row['Title'] . "</strong>. " . 
				$row['Description'] . ".</li>\n",
			"latex" => "\\item [{[}" . $row['ID'] . "{]}]" . $row['Authors'] .
				", \\emph{" . $row['Title'] . "}. " . 
				$row['Description'] . ".\n\n"));
	}
	output($outputstyle, array(
		"html" => "</ol>\n</div>\n",
		"latex" => "\\end{topic}\n\n"));
	//print("<script language=\"javascript\">\n");
	//print("toggle(getObject('publ_link'), 'publ');\n");
	//print("</script>\n");
	return;
}
// END PUBLICATIONS

// SKILLS
function do_skills($outputstyle) {
	output($outputstyle, array(
		"html" => "<h2>Skills</h2>\n",
		"latex" => "\section{Skills}\n"));
	$result = db_query("SELECT * FROM skills_categories");
	$counter = 0;
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
		$counter++;
		output($outputstyle, array(
			"html" => "<h3>" .
				"[<a id='ski" . $counter . "_link' href=\"javascript: void();\" " .
				"onclick = \"toggle(this, 'ski" . $counter ."');\" >" .
				"-</a>]\n" .
				$row['Description'] .
				"</h3>\n",
			"latex" => "\subsection{" . $row['Description'] . "}\n\n"));
		$result1 = db_query("SELECT * FROM skills WHERE Category = " . 
			$row['ID']);
		output($outputstyle, array(
			"html" => "<div id='ski" . $counter . "'><dl>\n",
			"latex" => "\\begin{topic}\n"));
		while($row1 = mysql_fetch_array($result1, MYSQL_ASSOC)){
			output($outputstyle, array(
				"html" => "<dt><strong>" . $row1['Title'] . "</strong></dt>\n" .
					"<dd>" . $row1['Description'] . "</dd>\n",
				"latex" => "\item [" . $row1['Title'] . "] " .
					$row1['Description'] . "\n\n"));
		}
		output($outputstyle, array(
			"html" => "</dl>\n</div>\n" .
				"<script language=\"javascript\">\n" .
				"toggle(getObject('ski" . $counter ."_link'), 'ski" . 
				$counter ."');\n" .
				"</script>\n",
			"latex" => "\\end{topic}\n"));
	}
	return;
}
// END SKILLS

// PROFESSIONAL ASSOCIATIONS
function do_professional_associations($outputstyle) {
	output($outputstyle, array(
		"html" => "<h2>" .
			"[<a id='assoc_link' href=\"javascript: void();\" " .
			"onclick = \"toggle(this, 'assoc');\" >" .
			"-</a>]\n" .
			"Professional Associations" .
			"</h2>\n",
		"latex" => "\\section{Professional Associations}\n\n"));
	$result = db_query("SELECT * FROM professional_associations");
	output($outputstyle, array(
		"html" => "<div id='assoc'><dl>\n",
		"latex" => "\\begin{topic}\n"));
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
		output($outputstyle, array(
			"html" => "<dt><strong>" . $row['Date'] . "</strong></dt>\n" .
				"<dd>" . $row['Title'] . "<br />\n" .
				$row['Description'] . "</dd>\n",
			"latex" => "\item [" . $row['Date'] . "] " .
				"\\textbf{" . $row['Title'] . "} " .
				$row['Description'] . "\n\n"));
	}
	output($outputstyle, array(
		"html" => "</dl>\n" .
			"</div>\n" .
			"<script language=\"javascript\">\n" .
			"toggle(getObject('assoc_link'), 'assoc');\n" .
			"</script>\n",
		"latex" => "\\end{topic}\n"));
	return;
}
// END PROFESSIONAL ASSOCIATIONS

// INTERESTS
function do_interests($outputstyle) {
	output($outputstyle, array(
		"html" => "<h2>Interests</h2>\n",
		"latex" => "\section{Interests}\n\n"));
	$result = db_query("SELECT * FROM personal_interests_categories");
	$counter = 0;
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
		$counter++;
		output($outputstyle, array(
			"html" => "<h3>" .
				"[<a id='int" . $counter . "_link' href=\"javascript: void();\" " .
				"onclick = \"toggle(this, 'int" . $counter ."');\" >" .
				"-</a>]\n" .
				$row['Description'] . "</h3>\n",
			"latex" => "\\subsection{" . $row['Description'] . "}\n\n"));
		$result1 = db_query(
			"SELECT * FROM personal_interests WHERE category = " . $row['ID'] . 
			" ORDER BY SortIndex ASC");
		output($outputstyle, array(
			"html" => "<div id='int" . $counter . "'><ul>\n",
			"latex" => "\\begin{itemize}\n"));
		while($row1 = mysql_fetch_array($result1, MYSQL_ASSOC)){
			output($outputstyle, array(
				"html" => "<li>" . $row1['Description'] . "</li>\n",
				"latex" => "\\item " . $row1['Description'] . "\n"));
		}
		output($outputstyle, array(
			"html" => "</ul>\n" .
				"</div>\n" .
				"<script language=\"javascript\">\n" .
				"toggle(getObject('int" . $counter ."_link'), 'int" . 
				$counter ."');\n" .
				"</script>\n",
			"latex" => "\\end{itemize}\n\n"));
	}
	return;
}
// END INTERESTS

// MARKS
function do_marks($outputstyle) {
	output($outputstyle, array(
		"html" => "<h2>" .
			"[<a id='marks_link' href=\"javascript: void();\" " .
			"onclick = \"toggle(this, 'marks');\" >" .
			"-</a>]\n" .
			"University Marks" . "</h2>\n",
		"latex" => "\section{University Marks}\n\n"));
	$result = db_query("SELECT * FROM marks");
	output($outputstyle, array(
		"html" => "<div id='marks'><table>\n" .
			"<tr> <td><strong>code</strong></td> " .
			"<td><strong>subject title</strong></td> " .
			"<td><strong>mark</strong></td> " .
			"<td><strong>grade</strong></td> </tr>\n",
		"latex" => "\\begin{longtable}{|l|l|r|l|}\n" .
			"\\hline code& subject title& mark& grade\\\\\n" .
			"\\hline\n\\hline \\endhead\n"));
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
        $mark = '-';
        if($row['Mark'] != 0) { $mark = $row['Mark']; }
		output($outputstyle, array(
			"html" => "<tr> " .
				"<td>" . $row['Code'] . "</td> " .
				"<td>" . $row['Title'] . "</td> " .
				"<td>" . $mark . "</td> " .
				"<td>" . $row['Grade'] . "</td> " .
				"</tr>\n",
			"latex" => $row['Code'] . "& " .
				$row['Title'] . "& " . 
				$mark . "& " .
				$row['Grade'] . "\\\\ \n\\hline "));
	}
	output($outputstyle, array(
		"html" => "</table>\n" .
			"</div>\n" .
			"<script language=\"javascript\">\n" .
			"toggle(getObject('marks_link'), 'marks');\n" .
			"</script>\n",
		"latex" => "\n\\end{longtable}\n\n"));
	return;
}
// END MARKS

// AWARDS
function do_awards($outputstyle) {
	output($outputstyle, array(
		"html" => "<h2>Awards</h2>\n",
		"latex" => "\section{Awards}\n\n"));
	$result = db_query("SELECT * FROM awards_categories");
	$counter = 0;
	while($row = mysql_fetch_array($result, MYSQL_ASSOC)){
		$counter++;
		output($outputstyle, array(
			"html" => "<h3>" .
				"[<a id='awd" . $counter . "_link' href=\"javascript: void();\" " .
				"onclick = \"toggle(this, 'awd" . $counter ."');\" >" .
				"-</a>]" .
				$row['Description'] . "</h3>\n",
			"latex" => "\\subsection{" . $row['Description'] . "}\n\n"));
		$result1 = db_query(
			"SELECT * FROM awards WHERE category = " . $row['ID'] . 
			" ORDER BY DateIndex ASC");
		output($outputstyle, array(
			"html" => "<div id='awd" . $counter . "'><ul>\n",
			"latex" => "\\begin{itemize}\n"));
		while($row1 = mysql_fetch_array($result1, MYSQL_ASSOC)){
			output($outputstyle, array(
				"html" => "<li>" . $row1['Description'] . "</li>\n",
				"latex" => "\item " . $row1['Description'] . "\n"));
		}
		output($outputstyle, array(
			"html" => "</ul>\n" .
				"</div>\n" .
				"<script language=\"javascript\">\n" .
				"toggle(getObject('awd" . $counter ."_link'), 'awd" . 
				$counter ."');\n" .
				"</script>\n",
			"latex" => "\\end{itemize}\n\n"));
	}
	return;
}
// END AWARDS

function output($output, $array) {
	global $handle;
	if(preg_match("/pdf(.*)/", $output, $matches)) {
		fwrite($handle, $array["latex" . $matches[1]]);
		return;
	}
	print($array[$output]);
	return;
}

?>

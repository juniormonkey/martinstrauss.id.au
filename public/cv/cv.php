<?php
include ("inc/cv.php");

global $type;
$type = 'full';
if($_REQUEST['type']) {
	$type = $_REQUEST['type'];
}

$outputStyle = 'html';
if($_REQUEST['output']) {
	$outputStyle = $_REQUEST['output'];
}

start($outputStyle, "Martin Strauss");

db_connect();

do_personal_info($outputStyle);

if ($type == 'brief') {
	do_skills($outputStyle);
	do_work_experience($outputStyle, "short");
	do_education($outputStyle, "short", $awards = false, $positions = false);
	do_other_training($outputStyle, "short");
	do_other_experience($outputStyle, "short");
} else if ($type == 'work') {
	do_professional_interests($outputStyle);
	do_skills($outputStyle);
	do_work_experience($outputStyle, "long");
	do_other_experience($outputStyle, "long");
	do_professional_associations($outputStyle);
	do_education($outputStyle, "long", $awards = false, $positions = false);
	do_other_training($outputStyle, "long");
} else if ($type == 'graduate') {
	do_professional_interests($outputStyle);
	do_skills($outputStyle);
	do_work_experience($outputStyle, "long");
	do_other_experience($outputStyle, "long");
	do_education($outputStyle, "long", $awards = true, $positions = true);
	do_other_training($outputStyle, "long");
	do_interests($outputStyle);
	do_marks($outputStyle);
	do_awards($outputStyle);
} else if ($type == 'casual') {
	do_skills($outputStyle);
	do_work_experience($outputStyle, "long");
	do_other_experience($outputStyle, "long");
	do_education($outputStyle, "long", $awards = true, $positions = true);
	do_other_training($outputStyle, "long");
	do_interests($outputStyle);
	do_awards($outputStyle);
} else if ($type == 'academic') {
	do_professional_interests($outputStyle);
	do_education($outputStyle, "long", $awards = true, $positions = false);
	do_other_training($outputStyle, "long");
	do_publications($outputStyle);
	do_work_experience($outputStyle, "long");
	do_other_experience($outputStyle, "long");
	do_awards($outputStyle);
	do_marks($outputStyle);
} else {
	do_professional_interests($outputStyle);
	do_education($outputStyle, "long", $awards = true, $positions = true);
	do_other_training($outputStyle, "long");
	do_work_experience($outputStyle, "long");
	do_other_experience($outputStyle, "long");
	do_publications($outputStyle);
	do_skills($outputStyle);
	do_professional_associations($outputStyle);
	do_interests($outputStyle);
	do_marks($outputStyle);
	do_awards($outputStyle);
}

do_end($outputStyle);

?>

<?php
if (!isset($_POST)) {
    $response = array('status' => 'Failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("config.php");

$sqlloadtutor = "SELECT tbl_tutors.tutor_id AS tutor_id, tbl_tutors.tutor_email AS tutor_email,tbl_tutors.tutor_phone AS tutor_phone,tbl_tutors.tutor_name AS tutor_name,tbl_tutors.tutor_description AS tutor_description,tbl_tutors.tutor_datereg AS tutor_datereg, GROUP_CONCAT(tbl_subjects.subject_name) AS subject_name FROM tbl_tutors INNER JOIN tbl_subjects ON tbl_tutors.tutor_id = tbl_subjects.tutor_id GROUP BY tbl_tutors.tutor_id";
$result = $conn->query($sqlloadtutor);
$number_of_result = $result->num_rows;

if ($result->num_rows > 0) {
    $tutors["tutors"] = array();
    while ($row = $result -> fetch_assoc()) {
        $tutorlist = array();
        $tutorlist['tutor_id'] = $row['tutor_id'];
        $tutorlist['tutor_email'] = $row['tutor_email'];
        $tutorlist['tutor_phone'] = $row['tutor_phone'];
        $tutorlist['tutor_name'] = $row['tutor_name'];
        $tutorlist['tutor_description'] = $row['tutor_description'];
        $tutorlist['tutor_datereg'] = $row['tutor_datereg'];
        $tutorlist['subject_name'] = $row['subject_name'];
        array_push($tutors["tutors"],$tutorlist);
    }
    $response = array('status' => 'success', 'data' => $tutors);
    sendJsonResponse($response);
    
} else {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);

}
function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
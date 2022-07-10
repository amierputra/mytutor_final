<?php
if (!isset($_POST)) {
    $response = array('status' => 'Failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("config.php");

$search = $_POST['search'];

$sqlloadsubject = "SELECT * FROM tbl_subjects WHERE subject_name LIKE '%$search%' ORDER BY subject_id DESC";
$result = $conn->query($sqlloadsubject);
$number_of_result = $result->num_rows;
if ($result->num_rows > 0) {
    $subjects["subjects"] = array();
    while ($row = $result -> fetch_assoc()) {
        $sublist = array();
        $sublist['subject_id'] = $row['subject_id'];
        $sublist['subject_name'] = $row['subject_name'];
        $sublist['subject_description'] = $row['subject_description'];
        $sublist['subject_price'] = $row['subject_price'];
        $sublist['tutor_id'] = $row['tutor_id'];
        $sublist['subject_sessions'] = $row['subject_sessions'];
        $sublist['subject_rating'] = $row['subject_rating'];
        
    }array_push($subjects["subjects"],$sublist);
    $response = array('status' => 'success', 'data' => $subjects);
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
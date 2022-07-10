<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("config.php");
$email = $_POST['email'];
$name = $_POST['name'];
$password = sha1($_POST['password']);
$phone = $_POST['phone'];
$address = $_POST['address'];
$base64image = $_POST['image'];

$sqlinsert = "INSERT INTO tbl_users (user_email, user_name, user_pass, user_phone, user_addr) VALUES ('$email','$name','$password','$phone','$address')";

if ($conn->query($sqlinsert) === TRUE) {
    $response = array('status' => 'success', 'data' => null);
    $filename = mysqli_insert_id($conn);
    $decoded_string = base64_decode($base64image);
    $path = '../assets/profiles/' . $filename . '.jpg';
    $is_written = file_put_contents($path, $decoded_string);
    sendJsonResponse($response);
    
} else{
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
}


function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
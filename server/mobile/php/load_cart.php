<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}
include_once("config.php");
$email = $_POST['email'];
$sqlloadcart = "SELECT tbl_carts.cart_id, tbl_carts.subject_id, tbl_carts.cart_qty, tbl_carts.cart_status, tbl_carts.payment_id, tbl_carts.cart_date, tbl_subjects.subject_name, tbl_subjects.subject_price FROM tbl_carts INNER JOIN tbl_subjects ON tbl_carts.subject_id = tbl_subjects.subject_id WHERE user_email = '$email' AND cart_status IS NULL";
$result = $conn->query($sqlloadcart);
$number_of_result = $result->num_rows;
if ($result->num_rows > 0) {
    //do something
    $total_payable = 0;
    $carts["cart"] = array();
    while ($rows = $result->fetch_assoc()) {
        
        $cartlist = array();
        $cartlist['cart_id']        = $rows['cart_id'];
        $cartlist['subject_id']     = $rows['subject_id'];
        $subprice                   = $rows['subject_price'];
        $cartlist['cart_qty']       = $rows['cart_qty'];
        $cartlist['cart_status']    = $rows['cart_status'];
        $cartlist['payment_id']     = $rows['payment_id'];
        $cartlist['cart_date']      = $rows['cart_date'];
        $cartlist['subject_name']   = $rows['subject_name'];
        $cartlist['subject_price']  = number_format((float)$subprice, 2, '.', '');
        $price                      = $rows['cart_qty'] * $subprice;
        $total_payable              = $total_payable + $price;
        $cartlist['pricetotal']     = number_format((float)$price, 2, '.', ''); 
        array_push($carts["cart"],$cartlist);
    }
    $response = array('status' => 'success', 'data' => $carts, 'total' => $total_payable);
    sendJsonResponse($response);
} else {
    $response = array('status' => 'Failed', 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray)
{
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}

?>
<?php

$con = mysqli_connect("localhost","root","","db_ios_upload") or die("connection failure");

$image = $_FILES['image']['tmp_name'];
$device = $_POST['device'];


if(empty($image) || empty($device)){
    echo json_encode(array('status'=>502));
}else{

    $img_id = uniqid() . '.jpg';

    move_uploaded_file($image, './image/'.$img_id);

    mysqli_query($con, "INSERT INTO image (image,device) VALUES ('$img_id','$device')");

    echo json_encode(array('status'=>200));

}


?>
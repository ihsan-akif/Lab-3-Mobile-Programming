<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];
$type = $_POST['type'];

$sql = "SELECT DATA.Total, DATA.Title, DATA.Description, DATA.Date, DATA.Type FROM DATA INNER JOIN USER WHERE USER.Email = '$email' ORDER BY DATA.Date DESC";

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["data"] = array();
    while ($row = $result->fetch_assoc())
    {
        $datalist = array();
        $datalist["email"] = $row["Email"];
        $datalist["total"] = $row["Total"];
        $datalist["title"] = $row["Title"];
        $datalist["description"] = $row["Description"];
        $datalist["date"] = $row["Date"];
        $datalist["type"] = $row["Type"];
        array_push($response["data"], $datalist);
    }
    echo json_encode($response);
}
else
{
    echo "Data Empty";
}
?>

<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT USER.Email, INCOME.IncomeTotal, INCOME.IncomeName, INCOME.IncomeDate FROM INCOME INNER JOIN USER ON USER.Email = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["income"] = array();
    while ($row = $result->fetch_assoc())
    {
        $datalist = array();
        $datalist["email"] = $row["Email"];
        $datalist["inctotal"] = $row["IncomeTotal"];
        $datalist["incname"] = $row["IncomeName"];
        $datalist["incdate"] = $row["IncomeDate"];
        array_push($response["income"], $datalist);
    }
    echo json_encode($response);
}
else
{
    echo "Income Empty";
}
?>

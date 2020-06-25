<?php
error_reporting(0);
include_once ("dbconnect.php");
$email = $_POST['email'];

if (isset($email)){
   $sql = "SELECT USER.Email, EXPENSE.ExpenseTotal, EXPENSE.ExpenseName, EXPENSE.ExpenseDate FROM EXPENSE INNER JOIN USER ON USER.Email = '$email'";
}

$result = $conn->query($sql);

if ($result->num_rows > 0)
{
    $response["expense"] = array();
    while ($row = $result->fetch_assoc())
    {
        $datalist = array();
        $datalist["email"] = $row["Email"];
        $datalist["exptotal"] = $row["ExpenseTotal"];
        $datalist["expname"] = $row["ExpenseName"];
        $datalist["expdate"] = $row["ExpenseDate"];
        array_push($response["expense"], $datalist);
    }
    echo json_encode($response);
}
else
{
    echo "Expense Empty";
}
?>

<?php
/* ------------------------------------------------------------
Booking Function Set
====================
Usage:
	include "[path_to_file]/bookfunction.php";

Parameter Note:
	$cn is a connection identifier for booking. Leave it as is $cn.
	$lg is a language identifier. possible value is "th", "en"

Function Set:
	getProvinceList($cn, $lg);
		Return: Text option for <select></select>
		Usage:
			<select ......>
			<?=getProvinceList($cn, "th")?>
			</select>
	
	getStation($cn, $uID, $pvID, $type, $lg);
		Return: Text option for <select></select>
		Usage:
			<select ......>
			<?=getStation($cn, 31, "source", "th")?>
			</select>
	
	getTimeTable($cn, $uID, $from, $to, $showDate);
		Return: Array of time table.
		Usage: varName = getTimeTable($cn, $uID, $from, $to, $showDate);
	
	putBooking($cn, $uID, $sID, $serviceCode, $amount, $passengerName, $telNo, $email, $passportNo, $note);
		Return: Array of booking result, bookNo + paymentDue.
		Usage: varName = putBooking($cn, $uID, $sID, $serviceCode, $amount, $passengerName, $telNo, $email, $passportNo, $note);
		Note: $email, $passportNo are optional.
	
	getBooking($cn, $bookingNo);
		Return: Array of booking data.
		Usage: varName = getBooking($cn, $bookingNo);
	
	confirmPayment($cn, $bookingNo, $process_by);
		Return: Array of payment result. (success. failure)
		Usage: varName = confirmPayment($cn, $bookingNo, $process_by);
		Note: $process_by is optional.
		
	planInfo($cn, $sID);
		Return: Array of plan info (Row, Col, WalkWay).
		Usage: varName = planInfo($cn, $sID);
		
	getSeatPlan($cn, $sID);
		Return: Array of seat plan.
		Usage: varName = getSeatPlan($cn, $sID);
		
	putBookingSeat($cn, $uID, $sID, $serviceCode, $selectedSeat, $passengerName, $telNo, $email, $passportNo, $note);
		Return: Array of booking result, bookNo + paymentDue.
		Usage: varName = putBooking($cn, $uID, $sID, $serviceCode, $selectedSeat, $passengerName, $telNo, $email, $passportNo, $note);
		Note: 
				$email, $passportNo are optional.
				$selectedSeat : string of selected seat ("1A-10, 2A-10")
				
	serviceAvailableSeat($cn, $sID, $seatName);
		Return: Boolean true - if seat available, false if seat was sold
		Usage: varName = serviceAvailableSeat($cn, $sID, $seatName);
		Note:
				$sID = Services ID from new time.
				$seatName = Single Seat number, 1A 2A ...
	
	refundBooking($conn, $bookingNo, $refundedNote);
		Return: Data of refunded value and refunded fee.
		Usage: varName = refundBooking($cn, "XXXXXXXX", "Customer change time...");
		
	addAg($conn, $agID, $agName, $contactName, $email, $tel);
		Return: an API Key for agency.
		Usage: varName = addAg($cn, "Agency ID", "Agency Name", "Contact Name", "Email", "Tel No.");
	
	topup($conn, $agApiKey);
		Return: Boolean true - if topup success, false if failure.
		Usage: varName = topup($cn, "Agency APIKey");
		
------------------------------------------------------------ */

/* Begin Function Definition */
function freeSeat($conn) {
	$now = date("Y-m-d H:i:s");
	
	$sql = "
			select b.bookingID, 
				b.agencyCost,
				b.bookingBy,
				u.uGroup
			from booking b
				join users u on (b.bookingBy = u.uID)
			where not bookingPaid 
				and not void 
				and not refunded 
				and reserveDue < '{$now}'
	";
	$res = mysqli_query($conn, $sql) or die(mysqli_error($conn));
	if (mysqli_num_rows($res)) {
		while ($row = mysqli_fetch_assoc($res)) {
			$sql = "
					update booking set
						void = '1',
						voidDate = '{$now}',
						voidBy = '88'
					where bookingID = '{$row["bookingID"]}'
			";
			mysqli_query($conn, $sql) or die(mysqli_error($conn));
			if ($row["uGroup"] == 2) {
				$sql = "
						update agency set 
							balance = balance + {$row["agencyCost"]} 
						where uID = '{$row["bookingBy"]}'
				";
				mysqli_query($conn, $sql) or die(mysqli_error($conn));
			}
		}
	}
	
}

function genCode($length = 8) {
    $characters = 'ABCDEFGHJKLMNOPQRSTUVWXYZ23456789';
	$randomString = '';
    for ($i = 0; $i < $length; $i++) {
        $randomString .= $characters[rand(0, strlen($characters) - 1)];
    }
    return $randomString;
}

function getData($conn, $table, $col, $key, $val) {
	$sql = "
			select	{$col} as returnVal
			from	{$table}
			where	{$key} = '{$val}'
	";
	$rs = mysqli_query($conn, $sql) or die(mysqli_error($conn));
	if (mysqli_num_rows($rs)) {
		$ds = mysqli_fetch_assoc($rs);
		return $ds["returnVal"];
	} else {
		return "";
	}
}

function getSeatCapacity($conn, $planID) {
	$sql = "
			select seat_plans.plan_id,
				seat_floors.floor_id,
				seat_details.seat_name
			from seat_plans join seat_floors using (plan_id)
				join seat_details using (floor_id)
			where plan_id = '{$planID}'
				and pos_type = '1'
	";
	$funcRs = mysqli_query($conn, $sql) or die("Cannot check seat capacity");
	return (mysqli_num_rows($funcRs));
}

function getSeatUsed($conn, $sID) {
	$sql = "
			select booking.sID,
				booking.seatName
			from booking
			where sID = '{$sID}'
				and not void 
				and not refunded
	";
	$funcRs = mysqli_query($conn, $sql) or die("Cannot check seat used");
	return (mysqli_num_rows($funcRs));
}

function getAgencyPrice($conn, $uID, $routeID, $startPointID, $stopPointID, $col = "price_v") {
	$sql = "
			select 	{$col}
			from	agency_routeprice
			where	uID = '{$uID}' 
				and routeID = '{$routeID}'
				and startPointID = '{$startPointID}'
				and stopPointID = '{$stopPointID}'
	";
	$rs = mysqli_query($conn, $sql) or die(mysqli_error($conn));
	if (mysqli_num_rows($rs)) {
		$ds = mysqli_fetch_assoc($rs);
		return $ds[$col];
	} else {
		return 0;
	}
}

function getProvinceList($conn, $lang = "th") {
	$sql = "select * from province where not hide";
	$rs = mysqli_query($conn, $sql) or die("Cannot get province list.");
	$sel = $lang == "th" ? "เลือก" : "Select";
	$option = "";
	if (mysqli_num_rows($rs)) {
		while ($ds = mysqli_fetch_assoc($rs)) {
			$option .= "<option value='{$ds["pvID"]}'>{$ds[$lang."Name"]}</option>";
		}
	}
	return $option;
}

function getStation($conn, $uID, $pvID, $type, $lang = "th") {
	$col = strtoupper($type) == "SOURCE" ? "sourcePointID" : "destinationPointID";
	$sql = "
			select distinct route.{$col} as pointID,
				stoppoint.pointName as thName,
				stoppoint.enName
			from users_route_in_sell join route using (routeID) 
				join stoppoint on (route.{$col} = stoppoint.pointID)
			where users_route_in_sell.uID = '{$uID}' and stoppoint.pvID = '{$pvID}'
	";
	$rs = mysqli_query($conn, $sql) or die("Cannot get {$type} station.");
	$sel = $lang == "th" ? "เลือก" : "Select";
	$option = "";
	if (mysqli_num_rows($rs)) {
		while ($ds = mysqli_fetch_assoc($rs)) {
			$option .= "<option value='{$ds["pointID"]}'>{$ds[$lang."Name"]}</option>";
		}
	}
	return $option;
}

function getTimeTable($conn, $uID, $from, $to, $showDate) {
	$now = date("Y-m-d H:i");
	$limitedTime = date("Y-m-d H:i", strtotime(date("Y-m-d H:i", strtotime($now)) . " +4 hours"));
	
	$fromTime = "00:00";
	$toTime = "23:59";
	$sql = "
			SELECT services.*, 
				users_route_in_sell.routeID,
				route.routeNo, 
				route.thName,
				route.enName,
				route.sourcePointID,
				route.destinationPointID
			FROM services inner join users_route_in_sell using (routeID)
				inner join route on (users_route_in_sell.routeID = route.routeID)
			WHERE NOT services.deleted
				AND users_route_in_sell.uID = '{$uID}'
				AND NOT users_route_in_sell.disabled
				AND route.onService 
				AND NOT route.deleted 
				AND route.sourcePointID = '{$from}'
				AND route.destinationPointID = '{$to}'
				AND services.sDate = '{$showDate}'
				AND services.forAgency
			ORDER BY services.routeID, sTime
	"; //AND services.sTime BETWEEN '{$fromTime}' AND '{$toTime}'
	$rs = mysqli_query($conn, $sql) or die("Cannot get time table.");
	if (mysqli_num_rows($rs)) {
		$data = array();
		$data["records"] = array();
		while ($ds = mysqli_fetch_assoc($rs)) {
			extract($ds);
			if ($plan_id == 0) continue;
			$serviceTime = date("Y-m-d H:i", strtotime("{$sDate} {$sTime}"));
			if ($serviceTime < $limitedTime) continue;
			$planCarType = getData($conn, "seat_plans", "carType", "plan_id", $plan_id);
			$seatTotal = getSeatCapacity($conn, $plan_id);
			$seatUsed = getSeatUsed($conn, $sID);
			$seatAvai = $seatTotal - $seatUsed;
			$sellPrice = getAgencyPrice($conn, $uID, $ds["routeID"], $ds["sourcePointID"], $ds["destinationPointID"], "price_{$planCarType}");
			$vipPrice = $sellPrice + 100;
			if ($planCarType == "v" or $planCarType == "s" or $planCarType == "m") {
				$item = array(
					"serviceID" => $sID,
					"serviceDate" => $sDate,
					"serviceTime" => substr($sTime, 0, 5),
					"routeNo" => $routeNo,
					"thRouteName" => $thName,
					"enRouteName" => $enName,
					"carNo" => $carNo,
					"carSequence" => $carSeq,
					"platForm" => $planCarType,
					"seatTotal" => $seatTotal,
					"seatUsed" => $seatUsed,
					"seatAvai" => $seatAvai,
					"sellPrice" => $sellPrice,
					"vipPrice" => $vipPrice
				);
				array_push($data["records"], $item);
			}
		}
		return $data;
	} else {
		return array("message" => "Data not found.");
	}
}

function putBooking($conn, $uID, $sID, $serviceCode = "00", $amount = 0, $passengerName, $telNo, $email = "", $passportNo = "", $note = "") {
	if ($amount < 1) return array("message" => "Invalid amount number of seat.");
	
	$sql = "
			select services.sID,
				services.sDate,
				services.sTime,
				services.plan_id,
				users_route_in_sell.routeID,
				route.sourcePointID,
				route.destinationPointID
			from services 
				join users_route_in_sell using (routeID)
				join route on (users_route_in_sell.routeID = route.routeID)
			where services.sID = '{$sID}' and users_route_in_sell.uID = '{$uID}'
	";
	$rs = mysqli_query($conn, $sql) or die("Cannot check service id.");
	
	if (!mysqli_num_rows($rs)) return array("message" => "Invalid service id.");
	
	$ds = mysqli_fetch_assoc($rs);
	
	$serviceTime = date("Y-m-d H:i", strtotime("{$ds["sDate"]} {$ds["sTime"]}"));
	$now = date("Y-m-d H:i");
	$serviceDue = date("Y-m-d H:i", strtotime(date("Y-m-d H:i", strtotime($serviceTime)) . " -4 hours"));
	
	if ($now > $serviceDue) return array("message" => "Booking must process 4 hour befor departure time. Local Time: {$now}. Due: {$serviceDue}");
	
	$seatTotal = getSeatCapacity($conn, $ds["plan_id"]);
	$seatUsed = getSeatUsed($conn, $sID);
	$seatAvai = $seatTotal - $seatUsed;
	
	if ($amount > $seatAvai) return array("message" => "Available seat is not enough. Available: {$seatAvai}. Total Booking: {$amount}");
	
	do {
		$bookingNo = genCode();
		$sql = "select bookingNo from booking where bookingNo = '{$bookingNo}' ";
		$rs = mysqli_query($conn, $sql) or die("Cannot get booking number.");
	} while (mysqli_num_rows($rs));
	
	$planCarType = getData($conn, "seat_plans", "carType", "plan_id", $ds["plan_id"]);
	$agencyPrice = getAgencyPrice($conn, $uID, $ds["routeID"], $ds["sourcePointID"], $ds["destinationPointID"], "price_{$planCarType}");
	$agencyCost = getAgencyPrice($conn, $uID, $ds["routeID"], $ds["sourcePointID"], $ds["destinationPointID"], "cost_{$planCarType}");
	$agencyPlan = getAgencyPrice($conn, $uID, $ds["routeID"], $ds["sourcePointID"], $ds["destinationPointID"], "plan_{$planCarType}");
	$seatPrice = $agencyPlan;
	
	$requestBooking = $agencyCost * $amount;
	$aType = getData($conn, "agency", "agencyType", "uID", $uID);
	$aBalance = getData($conn, "agency", "balance", "uID", $uID);
	$aCredit = getData($conn, "agency", "credit", "uID", $uID);
	switch ($aType) {
		case "C":
			$cUsed = 0 - $aBalance;
			$cUsed += $requestBooking;
			if ($cUsed >= $aCredit) return array("message" => "Please check your credit.");
			break;
		case "D":
			$aBalance -= $requestBooking;
			if ($aBalance <= 0) return array("message" => "Please check your balance.");
			break;
	}
	
	$servicePaymentDue = date("Y-m-d H:i", strtotime(date("Y-m-d H:i", strtotime($serviceDue)) . " +60 minutes"));
	if ($serviceCode == "02") { // Couter Service
		$today = date("Y-m-d");
		if ($today == $ds["sDate"]) { // Same day
			$paymentDue = $servicePaymentDue;
		} else { // Other day
			$getTime = date("H:i");
			$chkTime = "21:00";
			if ($getTime < $chkTime)  {
				$paymentDue = "{$today} 23:59";
			} else {
				$nextDay = date("Y-m-d", strtotime($today . " +1 Days"));
				if ($nextDay == $ds["sDate"]) {
					$paymentDue = $serviceDue;
				} else {
					$paymentDue = "{$nextDay} 23:59";
				}
			}
		}
	} else { // Credit || Debit Card || PayPal
		$paymentDue = date("Y-m-d H:i", strtotime(date("Y-m-d H:i", strtotime($now)) . " +45 minutes"));
	}
	$reserveDue = date("Y-m-d H:i", strtotime(date("Y-m-d H:i", strtotime($paymentDue)) . " +10 minutes"));
	
	if ($paymentDue > $servicePaymentDue) return array("message" => "Payment must process 3 hour befor departure time. Local Time: {$now}. Due: {$servicePaymentDue}");
	
	$now = date("Y-m-d H:i:s");
	$gender = "U";
	$bookingPaid = 0;
	$bookingReserve = 1;
	
	$sql = "
			SELECT services.sID,
				seat_plans.plan_id,
				seat_floors.floor_id,
				seat_details.*
			FROM services join seat_plans using (plan_id)
				join seat_floors on (services.plan_id = seat_floors.plan_id)
				join seat_details USING (floor_id)
			where sID = {$sID}
				and pos_type = '1'
				and seat_name not in (select seatName from booking where sID = {$sID} and not void and not refunded)
			ORDER by seat_id DESC
	";
	$rsSeat = mysqli_query($conn, $sql) or die("Cannot get available seat.");
	if (!mysqli_num_rows($rsSeat)) return array("message" => "Their is no available seat.");
	
	$saveAgencyPrice = $agencyPrice;
	$saveAgencyCost = $agencyCost;
	$saveAgencyPlan = $agencyPlan;
	$saveSeatPrice = $seatPrice;
	
	for ($i = 0; $i < $amount; $i++) {
		
		$seatData = mysqli_fetch_assoc($rsSeat);
		$vip = $seatData["seat_type"];
		
		if ($vip) {
			$agencyPrice = $saveAgencyPrice + 100;
			$agencyCost = $saveAgencyCost + 100;
			$agencyPlan = $saveAgencyPlan + 100;
			$seatPrice = $saveSeatPrice + 100;
		} else {
			$agencyPrice = $saveAgencyPrice;
			$agencyCost = $saveAgencyCost;
			$agencyPlan = $saveAgencyPlan;
			$seatPrice = $saveSeatPrice;
		}
		
		do {
			$serialNo = genCode(5) . "-" . genCode(5) . "-" . genCode(5) . "-" . genCode(5);
			$sql = "select serialNo from booking where serialNo = '{$serialNo}' ";
			$rs = mysqli_query($conn, $sql) or die("Cannot get ticket serial no.");
		} while (mysqli_num_rows($rs));
		
		$sql = "
				insert booking set
					bookingNo = '{$bookingNo}',
					serialNo = '{$serialNo}',
					sID = '{$sID}',
					travelFrom = '{$ds["sourcePointID"]}',
					travelTo = '{$ds["destinationPointID"]}',
					passengerName = '{$passengerName}',
					passengerTel = '{$telNo}',
					passengerCardID = '{$passportNo}',
					passengerEmail = '{$email}',
					passengerGender = '{$gender}',
					seatName = '{$seatData["seat_name"]}',
					seatType = '{$seatData["seat_type"]}',
					seatPrice = '{$seatPrice}',
					agencyPrice = '{$agencyPrice}',
					agencyCost = '{$agencyCost}',
					netTotal = '{$seatPrice}',
					bookingPaid = '{$bookingPaid}',
					bookingReserve = '{$bookingReserve}',
					bookingBy = '{$uID}',
					reserveDue = '{$reserveDue}',
					serviceCode = '{$serviceCode}',
					paymentDue = '{$paymentDue}',
					bookingNote = '{$note}'
					
		";
		mysqli_query($conn, $sql) or die("Cannot put booking record.");
		
		$sql = "
				update agency set 
					balance = balance - {$agencyCost} 
				where uID = '{$uID}'
		";
		mysqli_query($conn, $sql) or die("Cannot calculate balance.");
	}
	$data = array();
	$data["records"] = array();
	$item = array("bookingNo" => $bookingNo, "paymentDue" => $paymentDue);
	array_push($data["records"], $item);
	return $data;
}

function getBooking($conn, $bookingNo) {
	$sql = "select * from booking where bookingNo = '{$bookingNo}'";
	$rs = mysqli_query($conn, $sql) or die("Cannot get booking data.");
	if (mysqli_num_rows($rs)) {
		$data = array();
		$data["records"] = array();
		while ($ds = mysqli_fetch_assoc($rs)) {
			
			$plan_id = getData($conn, "services", "plan_id", "sID", $ds["sID"]);
			$planCarType = getData($conn, "seat_plans", "carType", "plan_id", $plan_id);
			
			$serviceDate = getData($conn, "services", "sDate", "sID", $ds["sID"]);
			$serviceTime = substr(getData($conn, "services", "sTime", "sID", $ds["sID"]), 0, 5);
			$carSeq = getData($conn, "services", "carSeq", "sID", $ds["sID"]);
			$carNo = (empty($carSeq) ? "" : "{$carSeq}-") . getData($conn, "services", "carNo", "sID", $ds["sID"]);
			
			$thSource = getData($conn, "stoppoint", "pointName", "pointID", $ds["travelFrom"]);
			$enSource = getData($conn, "stoppoint", "enName", "pointID", $ds["travelFrom"]);
			
			$thTarget = getData($conn, "stoppoint", "pointName", "pointID", $ds["travelTo"]);
			$enTarget = getData($conn, "stoppoint", "enName", "pointID", $ds["travelTo"]);
			
				$item = array(
					"bookingNo" => $ds["bookingNo"],
					"serialNo" => $ds["serialNo"],
					"serviceID" => $ds["sID"],
					"serviceDate" => $serviceDate,
					"serviceTime" => $serviceTime,
					"carNo" => $carNo,
					"platForm" => $planCarType,
					"sourceID" => $ds["travelFrom"],
					"thSourceName" => $thSource,
					"enSourceName" => $enSource,
					"destinationID" => $ds["travelTo"],
					"thDestinationName" => $thTarget,
					"enDestinationName" => $enTarget,
					"passengerName" => $ds["passengerName"],
					"telNo" => $ds["passengerTel"],
					"passportNo" => $ds["passengerCardID"],
					"email" => $ds["passengerEmail"],
					"seatNo" => $ds["seatName"],
					"price" => $ds["agencyPrice"],
					"bookingDate" => $ds["bookingDate"],
					"bookingPaid" => $ds["bookingPaid"],
					"getPaidOn" => $ds["getPaidOn"],
					"void" => $ds["void"],
					"paymentDue" => date("Y-m-d H:i", strtotime($ds["paymentDue"])),
					"serviceCode" => $ds["serviceCode"],
					"process_by" => $ds["process_by"]
				);
				array_push($data["records"], $item);

		}
		return $data;
	} else {
		return array("message" => "Data not found.");
	}
}

function confirmPayment($conn, $bookingNo, $process_by = '', $payment_channel = '', $payment_status = '', $channel_response_code = '', $channel_response_desc = '', $paid_agent = '', $paid_channel = '', $payment_scheme = '') {
	$now = date("Y-m-d H:i:s");
	$getPaidBy = 87; // Online Payment
	$sql = "
			update booking set
				bookingPaid = '1',
				getPaidOn = '{$now}',
				getPaidBy = '{$getPaidBy}',
				payment_channel = '{$payment_channel}',
				payment_status = '{$payment_status}',
				channel_response_code = '{$channel_response_code}',
				channel_response_desc = '{$channel_response_desc}',
				paid_agent = '{$paid_agent}',
				paid_channel = '{$paid_channel}',
				payment_scheme = '{$payment_scheme}',
				process_by = '{$process_by}'
			where bookingNo = '{$bookingNo}'
				and not refunded 
				and not void
	";
	mysqli_query($conn, $sql) or die("Cannot confirm payment.");
	$data = array();
	$data["records"] = array();
	if (mysqli_affected_rows($conn)) {
		$item = array("success" => 1);
	} else {
		$item = array("failure" => 1);
	}
	array_push($data["records"], $item);
	return ($data);
}

function planInfo($conn, $sID) {
	$sql = "
			SELECT services.sID, 
				services.plan_id, 
				seat_floors.floor_row, 
				seat_floors.floor_col, 
				seat_floors.floor_walkway
			FROM services 
				JOIN seat_floors USING (plan_id) 
			WHERE sID = '{$sID}' 
	";
	$res = mysqli_query($conn, $sql) or die(mysqli_error($conn));
	if (mysqli_num_rows($res)) {
		$info = array();
		$ds = mysqli_fetch_assoc($res);
		$data = array(
			"row" => $ds["floor_row"],
			"col" => $ds["floor_col"],
			"walkWay" => $ds["floor_walkway"]
		);
		array_push($info, $data);
	} else {
		$info = array("message" => "Data not found.");
	}
	return $info;
}

function getSeatPlan($conn, $sID) {
	$sql = "
			SELECT seatName 
			FROM `booking` 
			WHERE sID = '{$sID}' 
				AND NOT refunded 
				AND NOT void
	";
	$res = mysqli_query($conn, $sql) or die(mysqli_error($conn));
	if (mysqli_num_rows($res)) {
		$used = array();
		while ($ds = mysqli_fetch_assoc($res)) {
			array_push($used, $ds["seatName"]);
		}
	} else {
		$used = array("");
	}
	$sql = "
			SELECT services.sID, 
				services.plan_id, 
				seat_plans.selectionFee,
				seat_floors.floor_id, 
				seat_details.pos_x, 
				seat_details.pos_y, 
				seat_details.pos_type, 
				seat_details.seat_name, 
				seat_details.seat_type
			FROM services 
				JOIN seat_plans USING (plan_id)
				JOIN seat_floors USING (plan_id) 
				JOIN seat_details USING (floor_id)
			WHERE sID = '{$sID}'
	";
	$res = mysqli_query($conn, $sql) or die(mysqli_error($conn));
	if (mysqli_num_rows($res)) {
		$plan = array();
		while ($ds = mysqli_fetch_assoc($res)) {
			if ($ds["pos_type"] == 1) {
				$seatName = $ds["seat_name"];
				$seatType = $ds["seat_type"] ? "VIP" : "REG";
				$selectionFee = $ds["selectionFee"];
				$available = in_array($ds["seat_name"], $used) ? 0 : 1;
			} else {
				$seatName = "";
				$seatType = "N/A";
				$selectionFee = 0;
				$available = 0;
			}
			$seat = array(
				"posX" => $ds["pos_y"],
				"posY" => $ds["pos_x"],
				"seatName" => $seatName,
				"seatType" => $seatType,
				"selectionFee" => $selectionFee,
				"available" => $available
			);
			array_push($plan, $seat);
		}
	} else {
		$plan = array("message" => "Data not found.");
	}
	return $plan;
}

function putBookingSeat($conn, $uID, $sID, $serviceCode = "00", $selectedSeat, $passengerName, $telNo, $email = "", $passportNo = "", $note = "") {
	//$amount was replace by $selectedSeat refer to selected seat from booking page
	//if ($amount < 1) return array("message" => "Invalid amount number of seat.");
	$seatList = explode(",", $selectedSeat);
	$amount = count($seatList);
	if ($amount < 1) return array("message" => "Invalid amount number of seat.");
	
	$sql = "
			select services.sID,
				services.sDate,
				services.sTime,
				services.plan_id,
				users_route_in_sell.routeID,
				route.sourcePointID,
				route.destinationPointID
			from services 
				join users_route_in_sell using (routeID)
				join route on (users_route_in_sell.routeID = route.routeID)
			where services.sID = '{$sID}' and users_route_in_sell.uID = '{$uID}'
	";
	$rs = mysqli_query($conn, $sql) or die("Cannot check service id.");
	
	if (!mysqli_num_rows($rs)) return array("message" => "Invalid service id.");
	
	$ds = mysqli_fetch_assoc($rs);
	
	$serviceTime = date("Y-m-d H:i", strtotime("{$ds["sDate"]} {$ds["sTime"]}"));
	$now = date("Y-m-d H:i");
	$serviceDue = date("Y-m-d H:i", strtotime(date("Y-m-d H:i", strtotime($serviceTime)) . " -4 hours"));
	
	if ($now > $serviceDue) return array("message" => "Booking must process 4 hour befor departure time. Local Time: {$now}. Due: {$serviceDue}");
	
	$seatTotal = getSeatCapacity($conn, $ds["plan_id"]);
	$seatUsed = getSeatUsed($conn, $sID);
	$seatAvai = $seatTotal - $seatUsed;
	
	if ($amount > $seatAvai) return array("message" => "Available seat is not enough. Available: {$seatAvai}. Total Booking: {$amount}");
	
	do {
		$bookingNo = genCode();
		$sql = "select bookingNo from booking where bookingNo = '{$bookingNo}' ";
		$rs = mysqli_query($conn, $sql) or die("Cannot get booking number.");
	} while (mysqli_num_rows($rs));
	
	$planCarType = getData($conn, "seat_plans", "carType", "plan_id", $ds["plan_id"]);
	$agencyPrice = getAgencyPrice($conn, $uID, $ds["routeID"], $ds["sourcePointID"], $ds["destinationPointID"], "price_{$planCarType}");
	$agencyCost = getAgencyPrice($conn, $uID, $ds["routeID"], $ds["sourcePointID"], $ds["destinationPointID"], "cost_{$planCarType}");
	$agencyPlan = getAgencyPrice($conn, $uID, $ds["routeID"], $ds["sourcePointID"], $ds["destinationPointID"], "plan_{$planCarType}");
	$seatPrice = $agencyPlan;
	
	$requestBooking = $agencyCost * $amount;
	$aType = getData($conn, "agency", "agencyType", "uID", $uID);
	$aBalance = getData($conn, "agency", "balance", "uID", $uID);
	$aCredit = getData($conn, "agency", "credit", "uID", $uID);
	switch ($aType) {
		case "C":
			$cUsed = 0 - $aBalance;
			$cUsed += $requestBooking;
			if ($cUsed >= $aCredit) return array("message" => "Please check your credit.");
			break;
		case "D":
			$aBalance -= $requestBooking;
			if ($aBalance <= 0) return array("message" => "Please check your balance.");
			break;
	}
	
	$servicePaymentDue = date("Y-m-d H:i", strtotime(date("Y-m-d H:i", strtotime($serviceDue)) . " +60 minutes"));
	if ($serviceCode == "02") { // Couter Service
		$today = date("Y-m-d");
		if ($today == $ds["sDate"]) { // Same day
			$paymentDue = $servicePaymentDue;
		} else { // Other day
			$getTime = date("H:i");
			$chkTime = "21:00";
			if ($getTime < $chkTime)  {
				$paymentDue = "{$today} 23:59";
			} else {
				$nextDay = date("Y-m-d", strtotime($today . " +1 Days"));
				if ($nextDay == $ds["sDate"]) {
					$paymentDue = $serviceDue;
				} else {
					$paymentDue = "{$nextDay} 23:59";
				}
			}
		}
	} else { // Credit || Debit Card || PayPal
		$paymentDue = date("Y-m-d H:i", strtotime(date("Y-m-d H:i", strtotime($now)) . " +45 minutes"));
	}
	$reserveDue = date("Y-m-d H:i", strtotime(date("Y-m-d H:i", strtotime($paymentDue)) . " +10 minutes"));
	
	if ($paymentDue > $servicePaymentDue) return array("message" => "Payment must process 3 hour befor departure time. Local Time: {$now}. Due: {$servicePaymentDue}");
	
	$now = date("Y-m-d H:i:s");
	$gender = "U";
	$bookingPaid = 0;
	$bookingReserve = 1;
	
	$saveAgencyPrice = $agencyPrice;
	$saveAgencyCost = $agencyCost;
	$saveAgencyPlan = $agencyPlan;
	$saveSeatPrice = $seatPrice;
	
	//Check available seat
	for ($i = 0; $i < $amount; $i++) {
		if (trim($seatList[$i]) != "") {
			list($seatName, $fee) = explode("-", trim($seatList[$i]));
			$sql = "
					select seatName, sID
					from booking
					where seatName = '{$seatName}'
						and sID = '{$sID}'
						and not void and not refunded
			";
			$res = mysqli_query($conn, $sql) or die(mysqli_error($conn));
			if (mysqli_num_rows($res)) {
				return array("message" => "Seat {$seatName} not available.");
				exit();
			}
		}
	}
	
	//Put booking
	for ($i = 0; $i < $amount; $i++) {
		if (trim($seatList[$i]) != "") {
			list($seatName, $fee) = explode("-", trim($seatList[$i]));
			$sql = "
					select seat_floors.plan_id,
						seat_details.*
					from seat_floors join seat_details using (floor_id)
					where plan_id = '{$ds["plan_id"]}' and seat_name = '{$seatName}'	
			";
			$rsSeat = mysqli_query($conn, $sql) or die(mysqli_error($conn));
			if (!mysqli_num_rows($rsSeat)) {
				return array("message" => "Can not check seat type.");
				exit();
			}
			$seatData = mysqli_fetch_assoc($rsSeat);
			$vip = $seatData["seat_type"];
			
			if ($vip) {
				$agencyPrice = $saveAgencyPrice + 100;
				$agencyCost = $saveAgencyCost + 100;
				$agencyPlan = $saveAgencyPlan + 100;
				$seatPrice = $saveSeatPrice + 100;
			} else {
				$agencyPrice = $saveAgencyPrice;
				$agencyCost = $saveAgencyCost;
				$agencyPlan = $saveAgencyPlan;
				$seatPrice = $saveSeatPrice;
			}
			
			do {
				$serialNo = genCode(5) . "-" . genCode(5) . "-" . genCode(5) . "-" . genCode(5);
				$sql = "select serialNo from booking where serialNo = '{$serialNo}' ";
				$rs = mysqli_query($conn, $sql) or die("Cannot get ticket serial no.");
			} while (mysqli_num_rows($rs));
			
			$sql = "
					insert booking set
						bookingNo = '{$bookingNo}',
						serialNo = '{$serialNo}',
						sID = '{$sID}',
						travelFrom = '{$ds["sourcePointID"]}',
						travelTo = '{$ds["destinationPointID"]}',
						passengerName = '{$passengerName}',
						passengerTel = '{$telNo}',
						passengerCardID = '{$passportNo}',
						passengerEmail = '{$email}',
						passengerGender = '{$gender}',
						seatName = '{$seatData["seat_name"]}',
						seatType = '{$seatData["seat_type"]}',
						seatPrice = '{$seatPrice}',
						agencyPrice = '{$agencyPrice}',
						agencyCost = '{$agencyCost}',
						netTotal = '{$seatPrice}',
						selectionFee = '{$fee}',
						bookingPaid = '{$bookingPaid}',
						bookingReserve = '{$bookingReserve}',
						bookingBy = '{$uID}',
						reserveDue = '{$reserveDue}',
						serviceCode = '{$serviceCode}',
						paymentDue = '{$paymentDue}',
						bookingNote = '{$note}'
			";
			mysqli_query($conn, $sql) or die("Cannot put booking record.");
			
			$sql = "
					update agency set 
						balance = balance - {$agencyCost} 
					where uID = '{$uID}'
			";
			mysqli_query($conn, $sql) or die("Cannot calculate balance.");
			
		}
	}
	$data = array();
	$data["records"] = array();
	$item = array("bookingNo" => $bookingNo, "paymentDue" => $paymentDue);
	array_push($data["records"], $item);
	return $data;
}

function serviceAvailableSeat($conn, $sID, $seatName) {
	$sql = "
			select seatName 
			from booking
			where sID = '{$sID}'
				and seatName = '{$seatName}'
				and not void and not refunded
	";
	$res = mysqli_query($conn, $sql) or die(mysqli_error($conn));
	if (mysqli_num_rows($res)) {
		return 0;
	} else {
		return 1;
	}
}

function refundBooking($conn, $bookingNo, $refundedNote = "Agency refunded via API") {
	$sql = "
			select *
			from booking
			where bookingNo = '{$bookingNo}'
				and not void and not refunded
	";
	$res = mysqli_query($conn, $sql) or die(mysqli_error($conn));
	if (mysqli_num_rows($res)) {
		$sID = getData($conn, "booking", "sID", "bookingNo", $bookingNo);
		$sDateTime = getData($conn, "services", "CONCAT(sDate, ' ', sTime)", "sID", $sID);
		$refundDue = date("Y-m-d H:i:s", strtotime($sDateTime . " -4 Hours"));
		$now = date("Y-m-d H:i:s");
		
		if ($now > $refundDue) return array("message" => "Refund time over due.");
		
		$routeID = getData($conn, "services", "routeID", "sID", $sID);
		$refundFee = getData($conn, "route", "refundVal", "routeID", $routeID);
		$bookingBy = getData($conn, "booking", "bookingBy", "bookingNo", $bookingNo);
		
		$sql = "
				update booking set
					refunded = '1',
					refundedBy = '87',
					refundedDate = '{$now}',
					refundedVal = agencyCost - {$refundFee},
					refundedFee = '{$refundFee}',
					refundedNote = '{$refundedNote}'
				where bookingNo = '{$bookingNo}'
		"; // 87: Online Payment System
		mysqli_query($conn, $sql) or die(mysqli_error($conn));
		
		$sql = "select sum(refundedVal) as refVal, 
					sum(refundedFee) as refFee
				from booking
				where bookingNo = '{$bookingNo}'
		";
		$res = mysqli_query($conn, $sql) or die(mysqli_error($conn));
		if (mysqli_num_rows($res)) {
			$data["records"] = array();
			$row = mysqli_fetch_assoc($res);
			$item = array(
							"totalRefundedVal" => $row["refVal"], 
							"totalRefundedFee" => $row["refFee"]
			);
			array_push($data["records"], $item);
			
			$sql = "
					update agency set 
						balance = balance + {$row["refVal"]} 
					where uID = '{$bookingBy}'
			";
			mysqli_query($conn, $sql) or die(mysqli_error($conn));
			
			return $data;
		} else {
			return array("message" => "Refunded Data Lost.");
		}
	} else {
		return array("message" => "Invalid Booking Number.");
	}
}

function addAg($conn, $agID, $agName, $contactName, $email, $tel) {
	$agUser = "Agency-{$agID}";
	$agPass = md5(genCode());
	
	$sql = "
			insert users set
				uName = '{$agUser}',
				uPass = '{$agPass}',
				fullName = '{$agName}',
				uGroup = '{$uGroup}',
				pointID = '{$pointID}'
	";
	mysqli_query($conn, $sql) or die(json_encode(array("message" => "Cannot add agency user.")));
	$newUID = mysqli_insert_id($conn);
	
	do {
		$token = genCode(16);
		$sql = "select apiToken from agency where apiToken = '{$token}'";
		$rs = mysqli_query($conn, $sql) or die(json_encode(array("message" => mysqli_error($conn))));
	} while (mysqli_num_rows($rs));
	
	$sql = "
			insert agency set
				uID = '{$newUID}',
				agencyName = '{$agName}',
				contactPerson = '{$contactName}',
				contactEmail = '{$email}',
				contactTel = '{$tel}',
				agencyType = '{$agType}',
				credit = '{$agCredit}',
				openAPI = '1',
				apiToken = '{$token}',
				apiDomain = '{$agDomain}',
				createdBy = '{$addBy}'
	";
	mysqli_query($conn, $sql) or die(json_encode(array("message" => "Cannot add agency user.")));
	
	$data = array();
	$data["records"] = array();
	$item = array(
		"apiKey" => $token
	);
	array_push($data["records"], $item);
	return $data;
}

function topup($conn, $agApiKey) {
	$sql = "
			update agency set 
				balance = 0
			where apiToken = '{$agApiKey}' 
	";
	mysqli_query($conn, $sql) or die(json_encode(array("message" => "Cannot make topup.")));
	
	if (mysqli_affected_rows($conn)) {
		return 1;
	} else {
		return 0;
	}
}

/* End Function Definition */

$dbBookUser = "zimmu_jaywick";
$dbBookName = "zimmu_jaywick";
$dbBookPass = "QdC6uRDBxP3mRBMc";

$bkServName = "localhost";
$dbBookChrCode = "utf8";
$dbBookCollation = "utf8_general_ci";

$cn = mysqli_connect($bkServName, $dbBookUser, $dbBookPass, $dbBookName) or die(mysqli_connect_error());
mysqli_set_charset($cn, $dbBookChrCode) or die(mysqli_error($cn));
mysqli_query($cn, "SET collation_connection='{$dbBookCollation}'") or die(mysqli_error($cn));

/* Begin API Authen and Registration uID, Balance Caculation */
// $apiKey must select from agency database
$apiKey = "87AAHNB7UFBM8X5U"; 

if (isset($apiKey) and !empty($apiKey)) {
	$sql = "
			select 	* 
			from 	agency 
			where 	not deleted 
				and not disabled 
				and openAPI 
				and apiToken = '{$apiKey}' 
	";
	$rs = mysqli_query($cn, $sql) or die(mysqli_error($cn));
	if (!mysqli_num_rows($rs)) exit("Invalid API's key.");
	$ds = mysqli_fetch_assoc($rs);

	$agencyID = $ds["agencyID"];
	$agencyName = $ds["agencyName"];
	$aBalance = $ds["balance"];
	$aCredit = $ds["credit"];
	$aType = $ds["agencyType"];
	$uID = $ds["uID"];

	switch ($aType) {
		case "C":
			$cUsed = 0 - $aBalance;
			if ($cUsed >= $aCredit) exit("Please check your credit.");
			break;
		case "D":
			if ($aBalance <= 0) exit("Please check your balance.");
			break;
	}
}
/* End API Authen and Registration uID, Balance Caculation */

freeSeat($cn);

?>
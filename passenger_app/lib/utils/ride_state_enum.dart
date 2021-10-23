// enum RideState {
//   RIDERREQUEST,
//   ACCEPTED,
//   ONTRIP,
//   TRIPCOMPLETED,
//   RATEANDCOMMENT,
//   NOTRIP,
// }

enum RideState {
  ACCEPTED,
  ARRIVED,
  PICKED,
  DROPPED,
  DRIVERRATEANDCOMMENT,
  FINISHED,
  PASSENGERRATEANDCOMMENT,
  CONFIRMED,
  NOTRIP,
}

String getRideStateString(RideState topic) {
  if (topic == RideState.ACCEPTED) {
    return "ACCEPTED";
  } else if (topic == RideState.ARRIVED) {
    return "ARRIVED";
  } else if (topic == RideState.PICKED) {
    return "PICKED";
  } else if (topic == RideState.DROPPED) {
    return "DROPPED";
  } else if (topic == RideState.DRIVERRATEANDCOMMENT) {
    return "DRIVERRATEANDCOMMENT";
  } else if (topic == RideState.FINISHED) {
    return "FINISHED";
  } else if (topic == RideState.PASSENGERRATEANDCOMMENT) {
    return "PASSENGERRATEANDCOMMENT";
  } else if (topic == RideState.CONFIRMED) {
    return "CONFIRMED";
  } else {
    return "NOTRIP";
  }
}

RideState getRideState(String topic) {
  if (topic == "ACCEPTED") {
    return RideState.ACCEPTED;
  } else if (topic == "ARRIVED") {
    return RideState.ARRIVED;
  } else if (topic == "PICKED") {
    return RideState.PICKED;
  } else if (topic == "DROPPED") {
    return RideState.DROPPED;
  } else if (topic == "DRIVERRATEANDCOMMENT") {
    return RideState.DRIVERRATEANDCOMMENT;
  } else if (topic == "FINISHED") {
    return RideState.FINISHED;
  } else if (topic == "PASSENGERRATEANDCOMMENT") {
    return RideState.PASSENGERRATEANDCOMMENT;
  } else if (topic == "CONFIRMED") {
    return RideState.CONFIRMED;
  } else {
    return RideState.NOTRIP;
  }
}

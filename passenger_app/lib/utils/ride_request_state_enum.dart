// enum RideState {
//   RIDERREQUEST,
//   ACCEPTED,
//   ONTRIP,
//   TRIPCOMPLETED,
//   RATEANDCOMMENT,
//   NOTRIP,
// }

enum RideRequestState {
  SELECTVECHICLE,
  PENDING,
  ACCEPTED,
  TIMEOUT,
  NOTRIP,
}

String getRideRequestStateString(RideRequestState topic) {
  if (topic == RideRequestState.SELECTVECHICLE) {
    return "SELECTVECHICLE";
  } else if (topic == RideRequestState.PENDING) {
    return "PENDING";
  } else if (topic == RideRequestState.ACCEPTED) {
    return "ACCEPTED";
  } else if (topic == RideRequestState.TIMEOUT) {
    return "TIMEOUT";
  } else {
    return "NOTRIP";
  }
}

RideRequestState getRideRequestState(String topic) {
  if (topic == "SELECTVECHICLE") {
    return RideRequestState.SELECTVECHICLE;
  } else if (topic == "PENDING") {
    return RideRequestState.PENDING;
  } else if (topic == "ACCEPTED") {
    return RideRequestState.ACCEPTED;
  } else if (topic == "TIMEOUT") {
    return RideRequestState.TIMEOUT;
  } else {
    return RideRequestState.NOTRIP;
  }
}

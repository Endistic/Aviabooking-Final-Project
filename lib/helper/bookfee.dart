class BookingFee {
  final int id;
  final String seats;

  BookingFee({this.id, this.seats});

  factory BookingFee.fromJson(Map<String, dynamic> json) {
    return BookingFee(
      id: json['id'],
      seats: json['seats'],
    );
  }
}

enum NotificationEnum {
  common('common'),
  order('order'),
  vote('vote'),
  delivery('delivery'),
  voucher('voucher');

  const NotificationEnum(this.type);
  final String type;
}

extension ConvertNotification on String {
  NotificationEnum toEnum() {
    switch (this) {
      case 'common':
        return NotificationEnum.common;
      case 'order':
        return NotificationEnum.order;
      case 'vote':
        return NotificationEnum.vote;
      case 'delivery':
        return NotificationEnum.delivery;
      case 'voucher':
        return NotificationEnum.voucher;
      default:
        return NotificationEnum.common;
    }
  }
}
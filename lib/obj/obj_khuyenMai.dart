class obj_khuyenMai {
  String _ten;
  String _link;
  String _noiDung;
  String _thoiGian;

  obj_khuyenMai(this._ten, this._link, this._noiDung, this._thoiGian);

  String get thoiGian => _thoiGian;

  set thoiGian(String value) {
    _thoiGian = value;
  }

  String get noiDung => _noiDung;

  set noiDung(String value) {
    _noiDung = value;
  }

  String get link => _link;

  set link(String value) {
    _link = value;
  }

  String get ten => _ten;

  set ten(String value) {
    _ten = value;
  }
}

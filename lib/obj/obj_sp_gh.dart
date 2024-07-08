class obj_sp_gh {
  String _id;
  String _sTenSP;
  String _slink;
  int _iSoLuong;
  double _fThanhTien;
  double _fDa;
  double _fDuong;
  String sGhiChu;
  String _sTopping;
  double _giaGoc;

  obj_sp_gh(this._id, this._sTenSP, this._slink, this._iSoLuong, this._fThanhTien, this._fDa,
      this._fDuong, this.sGhiChu, this._sTopping, this._giaGoc);

  double get fDuong => _fDuong;

  set fDuong(double value) {
    _fDuong = value;
  }

  double get fDa => _fDa;

  set fDa(double value) {
    _fDa = value;
  }

  double get fThanhTien => _fThanhTien;

  set fThanhTien(double value) {
    _fThanhTien = value;
  }

  int get iSoLuong => _iSoLuong;

  set iSoLuong(int value) {
    _iSoLuong = value;
  }

  String get slink => _slink;

  set slink(String value) {
    _slink = value;
  }

  String get sTenSP => _sTenSP;

  set sTenSP(String value) {
    _sTenSP = value;
  }

  String get sTopping => _sTopping;

  set sTopping(String value) {
    _sTopping = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  double get giaGoc => _giaGoc;

  set giaGoc(double value) {
    _giaGoc = value;
  }
}

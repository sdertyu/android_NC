

class sanPham {
  String _idSP;
  late String _tenSP;
  late String _link;
  double _gia;
  String _loai;


  sanPham(this._idSP,this._tenSP, this._link, this._gia, this._loai);

  String get tenSP => _tenSP;

  set tenSP(String value) {
    _tenSP = value;
  }

  String get link => _link;

  set link(String value) {
    _link = value;
  }

  double get gia => _gia;

  set gia(double value) {
    _gia = value;
  }

  String get loai => _loai;

  set loai(String value) {
    _loai = value;
  }

  String get idSP => _idSP;

  set idSP(String value) {
    _idSP = value;
  }
}
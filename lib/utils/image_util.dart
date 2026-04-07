class ImageUtil {
  static const Map<String, String> keywordMap = {
    "hà nội": "hanoi", "hồ chí minh": "hcm", "sài gòn": "hcm",
    "đà nẵng": "danang", "đà lạt": "dalat", "nha trang": "nhatrang",
    "vũng tàu": "vungtau", "bà rịa": "vungtau",
    "hạ long": "halong", "quảng ninh": "halong",
    "sapa": "sapa", "lào cai": "sapa",
    "phú quốc": "phuquoc", "kiên giang": "phuquoc",
    "hội an": "hoian", "quảng nam": "hoian",
    "huế": "hue", "ninh bình": "ninhbinh",
    "hà giang": "hagiang", "mũi né": "muine", "phan thiết": "muine",
    "cần thơ": "cantho", "bến tre": "bentre", "tây ninh": "tayninh",
    "quy nhơn": "quynhon", "côn đảo": "condao", "vĩnh hy": "vinhhy",
    "an giang": "angiang", "bạc liêu": "bac_lieu", "bắc giang": "bacgiang",
    "bắc kạn": "backan", "bắc ninh": "bacninh", "bình định": "binhdinh",
    "bình dương": "binhduong", "bình phước": "binhphuoc", "bình thuận": "binhthuan",
    "cà mau": "camau", "cao bằng": "caobang", "đắk lắk": "daklak",
    "đắk nông": "daknong", "điện biên": "dienbien", "đồng nai": "dongnai",
    "đồng tháp": "dongthap", "gia lai": "gialai", "hà nam": "hanam",
    "hà tĩnh": "hatinh", "hải dương": "haiduong", "hải phòng": "haiphong",
    "hậu giang": "haugiang", "hòa bình": "hoabinh", "hưng yên": "hungyen",
    "kon tum": "kontum", "lai châu": "lai_chau", "lạng sơn": "langson",
    "long an": "longan", "nam định": "namdinh", "nghệ an": "nghean",
    "phú thọ": "phutho", "phú yên": "phuyen", "quảng bình": "quangbinh",
    "quảng ngãi": "quangngai", "quảng trị": "quangtri", "sóc trăng": "soc_trang",
    "sơn la": "sonla", "thái bình": "thaibinh", "thái nguyên": "thainguyen",
    "thanh hóa": "thanhhoa", "tiền giang": "tiengiang", "trà vinh": "travinh",
    "tuyên quang": "tuyenquang", "vĩnh long": "vinhlong", "vĩnh phúc": "vinhphuc",
    "yên bái": "yenbai"
  };

  static String getImg(String placeName, String modelDefaultUrl) {
    if (modelDefaultUrl.isNotEmpty && modelDefaultUrl.startsWith("http")) {
      return modelDefaultUrl;
    }

    String lowerName = placeName.toLowerCase();
    
    for (var entry in keywordMap.entries) {
      if (lowerName.contains(entry.key)) {
        return "assets/images/img_${entry.value}.png";
      }
    }

    return "assets/images/img_dalat.png";
  }
}

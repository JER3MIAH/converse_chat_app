const String baseSvgPath = 'assets/svgs/';
const String basePngPath = 'assets/pngs/';

// app icon
final String appIcon = 'app-icon'.png;

// svgs
final String sunIcon = 'sunIcon'.svg;
final String moonIcon = 'moonIcon'.svg;
final String searchIcon = 'searchIcon'.svg;
final String drawerIcon = 'drawerIcon'.svg;
final String settingIcon = 'settingIcon'.svg;
final String globeIcon = 'globeIcon'.svg;
final String logoutIcon = 'logoutIcon'.svg;
final String trashIcon = 'trashIcon'.svg;
final String sendIcon = 'sendIcon'.svg;
final String editIcon = 'editIcon'.svg;

// extensions
extension ImageExtension on String {
  // png paths
  String get png => '$basePngPath$this.png';
  // svgs path
  String get svg => '$baseSvgPath$this.svg';
}

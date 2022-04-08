const List<String> pageSizes = [
  'letter',
  'legal',
  '4x6',
  '3x5',
  '5x8',
  'a4',
  'a6',
  'a7',
  'label2.3x3.4', //dk-1234
  'label2.4x4', //dk-1202
  'label2.4', //dk-2205, dk-2251
  'label2x4',
  'label4x3', //rd roll
  'roll54', //dkn5224
  'roll57',
  'roll80',
  'roll102',
  '9mm',
  '12mm',
  '18mm',
  '24mm',
  '36mm',
  'banner',
];

const List<String> yesOrNo = [
  'YES',
  'NO',
];

const List<String> blackOrRed = [
  'BLACK',
  'RED',
];

const List<String> eastOrWest = [
  // use Roboto-Regular.ttf will support all western Romance fonts
  // this will also fix the $ sign bug
  // do not use opensans
  // when you switch between Roboto and ARIALUNI, be sure to change the
  // tast_data.dart for the default value so the West will be highlighted
//  'assets/Roboto-Regular.ttf',
  'assets/ARIALUNI.TTF',
  'assets/BiauKai.ttf',
  'assets/LongCang-Regular.ttf',
  'assets/MPLUSRounded1c-Light.ttf',
];

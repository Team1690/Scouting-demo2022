// import "package:flutter/material.dart";
// import "package:scouting_frontend/views/mobile/screens/input_view/input_view_vars.dart";

// class LeftTarmacSwitch extends StatelessWidget {
//   const LeftTarmacSwitch({
//     super.key,
//     required this.leftTarmac,
//     required this.onLeftTarmacChange,
//   });

//   final bool leftTarmac;
//   final void Function(bool leftTarmac) onLeftTarmacChange;

//   @override
//   Widget build(final BuildContext context) => Column(
//     crossAxisAlignment: CrossAxisAlignment.center,
//     child:
//       Row(
//         crossAxisAlignment: CrossAxisAlignment.end,
//         children: <Widget>[
//           const Expanded(
//             child: Text(
//               "Left Tarmac",
//             )
//           ),
//           Expanded(
//             child: Switch(
//               value: leftTarmac,
//               onChanged: onLeftTarmacChange,
//             )
//           ),
//             ]
//           ),
//         ]
//       )
//     ],
//   )
// }
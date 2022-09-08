import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/constants/routes.dart';
import 'package:testapp/custom_widgets.dart';
import 'package:testapp/services/cloud/cloud_service.dart';
import 'package:testapp/views/seller_pages/request_edit.dart';

class SellerRequests extends StatefulWidget {
  const SellerRequests({Key? key}) : super(key: key);

  @override
  State<SellerRequests> createState() => _SellerRequestsState();
}

class _SellerRequestsState extends State<SellerRequests> {
  String userId = FirebaseAuth.instance.currentUser!.uid;
  bool isActive = false;
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          shape: Border(
            bottom: BorderSide(
              color: Colors.grey[200]!,
            ),
          ),
          bottom: TabBar(
            tabs: [
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.task,
                      color: color3,
                    ),
                    const SizedBox(width: 5),
                    GenericText(
                      text: 'Active',
                      color: color5,
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.archive,
                      color: color3,
                    ),
                    const SizedBox(width: 5),
                    GenericText(
                      text: 'Archive',
                      color: color5,
                    ),
                  ],
                ),
              ),
            ],
          ),
          title: BigText(
            text: 'My Requests',
            color: color5,
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(requests);
            },
            icon: const Icon(Icons.info_outline_rounded),
            color: color5,
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(requests);
              },
              icon: const Icon(Icons.notifications_active_outlined),
              color: color5,
            ),
          ],
        ),
        body: const TabBarView(
          children: [
            SellerRequestsIsEmpty(),
            Center(
              child: Text('Page 2'),
            ),
          ],
        ),
      ),
    );
  }
}

class SellerRequestsIsEmpty extends StatelessWidget {
  const SellerRequestsIsEmpty({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GenericText(
              text: 'There are no requests at the moment!', color: color5),
          Lottie.asset('assets/no requests.json'),
          const SizedBox(height: 50),
          GenericButton(
              primaryColor: color3,
              pressColor: color2,
              text: 'Add a request',
              onPressed: () {
                Navigator.of(context).pushNamed(requests);
              },
              textColor: color2),
        ],
      ),
    );
  }
}

// SingleChildScrollView(
//       child: Padding(
//         padding: const EdgeInsets.all(25),
//         child: ClipRect(
//           child: Column(
//             children: [
//               GenericText(text: 'Current requests', color: color5),
//               GenericText2(
//                   text:
//                       'Note: once a delivery man accepts your requests, you will no longer be able to make changes to the orders.',
//                   color: color5),
//               Padding(
//                 padding: const EdgeInsets.all(15),
//                 child: Container(
//                   height: 2,
//                   color: color3,
//                 ),
//               ),
//               FutureBuilder(
//                 future: CloudService().getSellerRequests(userId: userId),
//                 builder: (BuildContext context, AsyncSnapshot snapshot) {
//                   switch (snapshot.connectionState) {
//                     case ConnectionState.waiting:
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                     case ConnectionState.done:
//                       isActive = snapshot.data[0].data()['is_active'];
//                       return Column(
//                         children: [
//                           Visibility(
//                             visible: isActive,
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 const Icon(Icons.circle_notifications),
//                                 GenericText(
//                                     text: 'Status: in delivery', color: color5),
//                               ],
//                             ),
//                           ),
//                           SizedBox(
//                             child: ListView.separated(
//                               separatorBuilder: (context, index) {
//                                 return const Divider(
//                                   height: 20,
//                                 );
//                               },
//                               physics: const NeverScrollableScrollPhysics(),
//                               shrinkWrap: true,
//                               itemCount: snapshot.data.length,
//                               itemBuilder: (context, index) {
//                                 final isDelivered =
//                                     snapshot.data[index].data()['is_delivered'];

//                                 final price =
//                                     snapshot.data[index].data()['price'];
//                                 final name =
//                                     snapshot.data[index].data()['name'];
//                                 final item =
//                                     snapshot.data[index].data()['item'];
//                                 final notes =
//                                     snapshot.data[index].data()['notes'];
//                                 final pic =
//                                     snapshot.data[index].data()['picture_url'];

//                                 final numberC =
//                                     snapshot.data[index].data()['number'];

//                                 final String address = snapshot.data[index]
//                                     .data()['address']
//                                     .split(',')[0];

//                                 final int number = index + 1;

//                                 return Expanded(
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       GenericText4(
//                                           text: 'order#$number',
//                                           color: color5,
//                                           stringWeight: FontWeight.w300),
//                                       Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Row(
//                                             children: [
//                                               const Icon(Icons.person),
//                                               GenericText4(
//                                                 text: 'Name: ',
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w300,
//                                               ),
//                                               GenericText4(
//                                                 text: name,
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w200,
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               const Icon(Icons.call),
//                                               GenericText4(
//                                                 text: 'Number: ',
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w300,
//                                               ),
//                                               GenericText4(
//                                                 text: numberC.toString(),
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w200,
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               const Icon(Icons.store),
//                                               GenericText4(
//                                                 text: 'Item: ',
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w300,
//                                               ),
//                                               GenericText4(
//                                                 text: item,
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w200,
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               const Icon(Icons.money),
//                                               GenericText4(
//                                                 text: 'price: ',
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w300,
//                                               ),
//                                               GenericText4(
//                                                 text: price.toString(),
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w200,
//                                               ),
//                                               const Icon(Icons.attach_money),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               const Icon(Icons
//                                                   .location_history_outlined),
//                                               GenericText4(
//                                                 text: 'Address: ',
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w300,
//                                               ),
//                                               GenericText4(
//                                                 text: address,
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w200,
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               const Icon(Icons.textsms),
//                                               GenericText4(
//                                                 text: 'Notes: ',
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w300,
//                                               ),
//                                               GenericText4(
//                                                 text: notes,
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w200,
//                                               ),
//                                             ],
//                                           ),
//                                           Row(
//                                             children: [
//                                               const Icon(Icons.image),
//                                               GenericText4(
//                                                 text: 'Item image: ',
//                                                 color: color5,
//                                                 stringWeight: FontWeight.w300,
//                                               ),
//                                             ],
//                                           ),
//                                           GestureDetector(
//                                             onTap: () {
//                                               showDialog(
//                                                 context: context,
//                                                 builder: (context) {
//                                                   return Material(
//                                                     type: MaterialType
//                                                         .transparency,
//                                                     child: Container(
//                                                       height: 120,
//                                                       decoration: BoxDecoration(
//                                                         image: DecorationImage(
//                                                           image:
//                                                               NetworkImage(pic),
//                                                           fit: BoxFit.contain,
//                                                         ),
//                                                       ),
//                                                     ),
//                                                   );
//                                                 },
//                                               );
//                                             },
//                                             child: Container(
//                                               height: 120,
//                                               decoration: BoxDecoration(
//                                                 border: Border.all(
//                                                   color: color4,
//                                                   width: 5,
//                                                 ),
//                                                 shape: BoxShape.circle,
//                                                 image: DecorationImage(
//                                                   image: NetworkImage(pic),
//                                                   fit: BoxFit.contain,
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                           Visibility(
//                                             visible: !isActive,
//                                             child: Padding(
//                                               padding: const EdgeInsets.all(25),
//                                               child: Row(
//                                                 children: [
//                                                   Expanded(
//                                                     child: ElevatedButton(
//                                                       style: ElevatedButton
//                                                           .styleFrom(
//                                                         onPrimary: color3,
//                                                         primary: color2,
//                                                         fixedSize: Size(
//                                                             MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width *
//                                                                 .8,
//                                                             60),
//                                                         shape:
//                                                             RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(20),
//                                                         ),
//                                                       ),
//                                                       onPressed: () {
//                                                         Navigator.of(context)
//                                                             .push(
//                                                           MaterialPageRoute(
//                                                             builder: (context) =>
//                                                                 EditRequests(
//                                                                     cname:
//                                                                         name),
//                                                           ),
//                                                         );
//                                                       },
//                                                       child: GenericText4(
//                                                         text: 'Edit',
//                                                         color: color5,
//                                                         stringWeight:
//                                                             FontWeight.w300,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                   const SizedBox(width: 15),
//                                                   Expanded(
//                                                     child: ElevatedButton(
//                                                       style: ElevatedButton
//                                                           .styleFrom(
//                                                         onPrimary: color3,
//                                                         primary: color2,
//                                                         fixedSize: Size(
//                                                             MediaQuery.of(
//                                                                         context)
//                                                                     .size
//                                                                     .width *
//                                                                 .8,
//                                                             60),
//                                                         shape:
//                                                             RoundedRectangleBorder(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(20),
//                                                         ),
//                                                       ),
//                                                       onPressed: () {
//                                                         ScaffoldMessenger.of(
//                                                                 context)
//                                                             .showSnackBar(
//                                                           const SnackBar(
//                                                             content: Text(
//                                                                 'Long press to delete entry'),
//                                                           ),
//                                                         );
//                                                       },
//                                                       onLongPress: () async {
//                                                         await CloudService()
//                                                             .deleteSellerRequest(
//                                                                 userId: userId,
//                                                                 name: name);
//                                                         setState(() {});
//                                                       },
//                                                       child: GenericText4(
//                                                         text: 'Delete',
//                                                         color: color5,
//                                                         stringWeight:
//                                                             FontWeight.w300,
//                                                       ),
//                                                     ),
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                           ),
//                                           Visibility(
//                                             visible: isDelivered ?? false,
//                                             child: Center(
//                                               child: Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(25),
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                     border: Border.all(
//                                                       color: Colors.grey[200]!,
//                                                     ),
//                                                     borderRadius:
//                                                         BorderRadius.circular(
//                                                             50),
//                                                   ),
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             15),
//                                                     child: Row(
//                                                       crossAxisAlignment:
//                                                           CrossAxisAlignment
//                                                               .center,
//                                                       mainAxisAlignment:
//                                                           MainAxisAlignment
//                                                               .center,
//                                                       children: [
//                                                         GenericText(
//                                                           text: 'Delivered',
//                                                           color: color5,
//                                                         ),
//                                                         const SizedBox(
//                                                             width: 15),
//                                                         const Icon(
//                                                           Icons
//                                                               .task_alt_outlined,
//                                                           color: Colors.green,
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 ),
//                                               ),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 );
//                               },
//                             ),
//                           ),
//                         ],
//                       );

//                     default:
//                       return const Center(
//                         child: CircularProgressIndicator(),
//                       );
//                   }
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
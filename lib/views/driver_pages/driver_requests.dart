import 'package:flutter/material.dart';
import 'package:testapp/constants/colors.dart';
import 'package:testapp/custom_widgets.dart';

class DriverRequestsView extends StatefulWidget {
  const DriverRequestsView({Key? key}) : super(key: key);

  @override
  State<DriverRequestsView> createState() => _DriverRequestsViewState();
}

class _DriverRequestsViewState extends State<DriverRequestsView> {
  final bool _pinned = true;
  final bool _snap = false;
  final bool _floating = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: _pinned,
            snap: _snap,
            floating: _floating,
            expandedHeight: 200.0,
            flexibleSpace: FlexibleSpaceBar(
              title: GenericText(
                text: 'Deliveries',
                color: color2,
              ),
              background: const Image(
                fit: BoxFit.cover,
                image: AssetImage('assets/intro screen.jpg'),
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 30,
              child: Center(
                child: Text('Scroll down to see next deliveries'),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: 400,
                  decoration: BoxDecoration(
                    color: color4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GenericText(
                        text: 'Check current requests',
                        color: color2,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 2,
                        color: color1,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: color2,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GenericText(
                                  text: 'Maxwell Norman',
                                  color: color4,
                                ),
                                const Expanded(child: SizedBox()),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.message),
                                ),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.location_on_outlined,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 2.5,
                              color: color4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GenericText(
                                  text: 'Item #3',
                                  color: color4,
                                ),
                                const Expanded(child: SizedBox()),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                      Icons.photo_size_select_actual_rounded),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // This is fot the future requests
              Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  height: 400,
                  decoration: BoxDecoration(
                    color: color4,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GenericText(
                        text: 'Check available requests',
                        color: color2,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 2,
                        color: color1,
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        color: color2,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GenericText(
                                  text: 'Maxwell Norman',
                                  color: color4,
                                ),
                                const Expanded(child: SizedBox()),
                                IconButton(
                                  onPressed: () {},
                                  icon: const Icon(Icons.message),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            Container(
                              height: 2.5,
                              color: color4,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                GenericText(
                                  text: '27 Customers',
                                  color: color4,
                                ),
                                const Expanded(child: SizedBox()),
                                const Icon(Icons.location_on_outlined),
                                const SizedBox(
                                  width: 5,
                                ),
                                GenericText(
                                  text: 'Milan',
                                  color: color4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

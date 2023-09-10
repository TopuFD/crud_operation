import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class page extends StatefulWidget {
  const page({super.key});

  @override
  State<page> createState() => _pageState();
}

class _pageState extends State<page> {
  TextEditingController _controller = TextEditingController();
  TextEditingController _updateData = TextEditingController();
  Box? contactBox;
  @override
  void initState() {
    contactBox = Hive.box("contact_list");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 40, left: 25, right: 25),
        child: Column(
          children: [
            TextFormField(
              controller: _controller,
            ),
            SizedBox(
                width: 400,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      final userInput = _controller.text;
                      await contactBox!.add(userInput);
                      Fluttertoast.showToast(msg: "contact is added");
                      _controller.clear();
                    } catch (e) {
                      Fluttertoast.showToast(msg: "some has error");
                    }
                  },
                  child: Text("Add to card"),
                )),
            Expanded(
                child: ValueListenableBuilder(
              valueListenable: contactBox!.listenable(),
              builder: (BuildContext context, value, Widget? child) {
                return ListView.builder(
                    itemCount: contactBox!.keys.toList().length,
                    itemBuilder: (_, index) {
                      return Card(
                        elevation: 4,
                        child: ListTile(
                          title: Text(contactBox!.getAt(index).toString()),
                          trailing: SizedBox(
                              width: MediaQuery.of(context).size.width / 4.5,
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (_) {
                                                return Dialog(
                                                  backgroundColor: Colors.white,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 5,left: 10,right: 10),
                                                    child: Container(
                                                      height: 250,
                                                      child: Column(
                                                        children: [
                                                          TextFormField(
                                                            controller:
                                                                _updateData,
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.black),
                                                          ),
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                          ElevatedButton(
                                                              onPressed:
                                                                  () async {
                                                                try {
                                                                  final updateData =
                                                                      _updateData
                                                                          .text;
                                                                  if (updateData
                                                                      .isNotEmpty) {
                                                                    contactBox!.putAt(
                                                                        index,
                                                                        updateData);
                                                                    _updateData
                                                                        .clear();
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "update added");
                                                                    Navigator.pop(
                                                                        context);
                                                                  } else {
                                                                    Fluttertoast
                                                                        .showToast(
                                                                            msg:
                                                                                "write something");
                                                                  }
                                                                } catch (e) {
                                                                  Fluttertoast
                                                                      .showToast(
                                                                          msg:
                                                                              e.toString());
                                                                }
                                                              },
                                                              child: Text(
                                                                  "Edit to card"))
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        icon: Icon(Icons.edit)),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: IconButton(
                                        onPressed: () {
                                          contactBox!.deleteAt(index);
                                        },
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                        )),
                                  )
                                ],
                              ),
                            ),
                        ),
                      );
                    });
              },
            ))
          ],
        ),
      ),
    );
  }
}

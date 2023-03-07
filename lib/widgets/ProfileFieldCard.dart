import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:restart/assets/constants.dart';
import 'package:restart/widgets/GlassCards/GlassCard.dart';

class ProfileFieldCard extends StatefulWidget {
  ProfileFieldCard({
    this.maxLines,
    required this.title,
    required this.value,
    Key? key,
  }) : super(key: key);

  String title;
  String
      value; //!TBH we dont need to set this value in the widget constructor, might be better to just call the api within each individual card for the diff email/name/address
  int? maxLines;

  @override
  State<ProfileFieldCard> createState() => _ProfileFieldCardState();
}

class _ProfileFieldCardState extends State<ProfileFieldCard> {
  late String newValue = "";
  bool submitting = false;
  @override
  void initState() {
    newValue = widget.value;

    // TODO: implement initState
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    void doSubmit() {
      // Validate returns true if the form is valid, or false otherwise.
      if (_formKey.currentState!.validate()) {
        // If the form is valid, display a snackbar. In the real world,
        // you'd often call a server or save the information in a database.

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Processing Data...'),
              duration: const Duration(milliseconds: 900)),
        );
        Future.delayed(const Duration(milliseconds: 1000), () {
          //TODO: Replace with creating firebase doc and saving it
// Here you can write your code
          setState(() {
            submitting = false;
            newValue = widget.value;
          });
          Navigator.pop(context);
        });
      }
    }

    return Stack(
      alignment: AlignmentDirectional.centerEnd,
      children: [
        GlassCard(
            height: MediaQuery.of(context).size.height * 10 / 100,
            child: Padding(
              padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 5 / 100,
                  top: MediaQuery.of(context).size.height * 1 / 100,
                  bottom: MediaQuery.of(context).size.height * 1.5 / 100),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                        width: MediaQuery.of(context).size.width * 60 / 100,
                        child: Text(widget.title,
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: MediaQuery.of(context).size.height *
                                    1.8 /
                                    100))),
                    Container(
                        alignment: AlignmentDirectional.centerStart,
                        width: MediaQuery.of(context).size.width * 60 / 100,
                        height: MediaQuery.of(context).size.height * 5 / 100,
                        padding: EdgeInsets.only(
                            left: MediaQuery.of(context).size.width * 2 / 100),
                        child: AutoSizeText(
                          widget.value,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: widget.maxLines ?? 1,
                        ))
                  ]),
            )),
        Positioned(
          right: MediaQuery.of(context).size.width * 5 / 100,
          child: SizedBox(
              height: MediaQuery.of(context).size.height * 10 / 100,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(160, 255, 255, 255),
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(DEFAULT_RADIUS),
                          bottomRight: Radius.circular(DEFAULT_RADIUS)),
                    ),
                  ),
                  onPressed: () => showDialog(
                      barrierColor: Color.fromARGB(131, 100, 100, 100),
                      context: context,
                      builder: (BuildContext context) {
                        return Form(
                          key: _formKey,
                          child: Dialog(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0)), //this right here
                            child: GlassCard(
                              height:
                                  MediaQuery.of(context).size.height * 25 / 100,
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        MediaQuery.of(context).size.width *
                                            5 /
                                            100,
                                    vertical:
                                        MediaQuery.of(context).size.height *
                                            3 /
                                            100),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Change " + widget.title),
                                    TextFormField(
                                      decoration: InputDecoration(
                                          hintText:
                                              "What would you like to change it to?"),
                                      textInputAction: TextInputAction.next,

                                      textAlign: TextAlign.start,
                                      // The validator receives the text that the user has entered.
                                      onChanged: (val) {
                                        if (val.length > 0) {
                                          setState(() {
                                            newValue = val;
                                          });
                                        }
                                      },
                                      validator: (newValue) {
                                        if (newValue == null ||
                                            newValue.isEmpty) {
                                          return 'Please enter a valid reading';
                                        }
                                        return null;
                                        // doSubmit();
                                      },
                                      onFieldSubmitted: (e) async {
                                        setState(() {
                                          submitting = true;
                                        });
                                        doSubmit();
                                        print("E" + e.toString());

                                        // doSubmit();
                                      },
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              30 /
                                              100,
                                          child: OutlinedButton(
                                            onPressed: () {
                                              setState(() {
                                                newValue = widget.value;
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              "Cancel",
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              30 /
                                              100,
                                          child: ElevatedButton(
                                            onPressed: submitting == true
                                                ? null
                                                : () async {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    setState(() {
                                                      submitting = true;
                                                    });
                                                    doSubmit();
                                                  },
                                            child: Text(
                                              "Save",
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                  child: Icon(
                    Icons.edit,
                    color: Theme.of(context).primaryColor,
                  ))),
        ),
      ],
    );
  }
}

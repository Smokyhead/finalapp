import 'package:finalapp/constants.dart';
import 'package:finalapp/models/users.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class ManageServices extends StatefulWidget {
  const ManageServices({super.key});

  @override
  State<StatefulWidget> createState() => _ManageServicesState();
}

class _ManageServicesState extends State<ManageServices> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: AppBar(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          )),
          backgroundColor: kPrimaryColor,
          foregroundColor: Colors.white,
          title: const Text("Mes services"),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          color: kPrimaryLightColor,
          elevation: 20,
          height: 70,
          child: TextButton(
            style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(kPrimaryColor)),
            onPressed: () {},
            child: const Text(
              "Sauvegarder les modifications",
              style: TextStyle(fontSize: 18),
            ),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Mes services",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  color: const Color.fromARGB(255, 228, 239, 248),
                  height: 500,
                  child: ListView.separated(
                    separatorBuilder: (context, index) => const Divider(
                      thickness: 1,
                    ),
                    itemCount: Doctor.services.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: Text((index + 1).toString()),
                        title: Text(
                          Doctor.services[index],
                          style: const TextStyle(fontSize: 18),
                        ),
                        trailing: CircleAvatar(
                          radius: 15,
                          backgroundColor:
                              const Color.fromARGB(255, 93, 79, 78),
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              IconlyBold.delete,
                              size: 15,
                            ),
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 60,
                  child: TextButton(
                    style: ButtonStyle(
                        padding: MaterialStateProperty.all(
                            const EdgeInsets.symmetric(horizontal: 20)),
                        backgroundColor:
                            MaterialStateProperty.all(kPrimaryLightColor),
                        elevation: MaterialStateProperty.all(2),
                        foregroundColor:
                            MaterialStateProperty.all(kPrimaryColor)),
                    onPressed: () {},
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text(
                          "Ajoutez services",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.add,
                          size: 35,
                        )
                      ],
                    ),
                  ),
                ),
              ]),
        ),
      ),
    );
  }
}

class MultiSelect extends StatefulWidget {
  final List<String> items;
  const MultiSelect({super.key, required this.items});

  @override
  State<MultiSelect> createState() => _MultiSelectState();
}

class _MultiSelectState extends State<MultiSelect> {
  final List<String> selectedItems = [];

  void serviceChange(String itemValue, bool isSelected) {
    setState(() {
      if (isSelected) {
        selectedItems.add(itemValue);
      } else {
        selectedItems.remove(itemValue);
      }
    });
  }

  void cancel() {
    Navigator.pop(context);
  }

  void submit() {
    Navigator.pop(context, selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        title: const Text(
          "Choisissez vos services:",
          style: TextStyle(color: kPrimaryColor),
        ),
        content: SingleChildScrollView(
            child: ListBody(
                children: widget.items
                    .map((item) => CheckboxListTile(
                        title: Text(item),
                        controlAffinity: ListTileControlAffinity.leading,
                        value: selectedItems.contains(item),
                        onChanged: (isChecked) =>
                            serviceChange(item, isChecked!)))
                    .toList())),
        actions: [
          TextButton(
            onPressed: submit,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(kPrimaryColor),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
            ),
            child: const Text("Valider"),
          ),
          TextButton(
              onPressed: cancel,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(kPrimaryColor),
                foregroundColor: MaterialStateProperty.all(Colors.white),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
              ),
              child: const Text("Annuler"))
        ]);
  }
}

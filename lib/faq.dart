import 'dart:ui';

import 'package:covac/utils/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'main.dart';

class FAQPage extends StatefulWidget {
  @override
  _FAQPageState createState() => _FAQPageState();
}

class _FAQPageState extends State<FAQPage> {
  List<Item> _data = generateItem();

  Widget _buildListPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>(
        (Item item) {
          return ExpansionPanel(
              headerBuilder: (BuildContext context, bool isExpanded) {
                return ListTile(
                    title: Text(
                  item.headerValue,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ));
              },
              body: ListTile(
                title: Text(item.expandedValue),
                onTap: () {},
              ),
              isExpanded: item.isExpanded);
        },
      ).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: _buildListPanel(),
        ),
      ),
      appBar: AppBar(
        title: Text(
          "Frequently Asked Questions",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              size: 30,
              color: Colors.white,
            ),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => MyApp()),
                  (route) => false);
            },
          )
        ],
        backgroundColor: kPrimaryColor,
        elevation: 0,
        centerTitle: true,
        textTheme: Theme.of(context).textTheme,
      ),
    );
  }
}

class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Item({this.expandedValue, this.headerValue, this.isExpanded = false});
}

List<Item> generateItem() {
  List questions = [
    "Is it mandatory to take the vaccine?",
    "Is the vaccine safe as it is being tested and introduced in a short span of time?",
    "Can a person presently having COVID-19 (confirmed or suspected) infection be vaccinated?",
    "Is it necessary for a COVID recovered person to take the vaccine?",
    "Out of the multiple vaccines available, how is one or more vaccine chosen for administration?",
    "Can a person get the COVID-19 vaccine without registration with Health Department?",
    "Will a Photo / ID be required at the time of registration?",
    "If one is taking medicines for illnesses like Cancer, Diabetes, Hypertension etc, can she/he take the COVID19 vaccine?",
    "What about the possible side-effects from COVID-19 vaccine?",
    "Does one need to follow preventive measures such as wearing a mask, hand sanitization,social distancing after receiving the COVID 19 vaccine?",
    "How many doses of the vaccine would have to be taken by me and at what interval?",
    "When would antibodies develop?After taking first dose,after taking second dose, or much later?",
  ];
  List answers = [
    "Vaccination for COVID-19 is voluntary.However, it is advisable to receive the complete schedule of COVID-19 vaccine for protecting one-self against this disease and also to limit the spread of this disease to the close contacts including family members, friends, relatives and co-workers.",
    "Vaccines that is introduced in the country only after the regulatory bodies clear it based on its safety and efficacy.",
    "Person with confirmed or suspected COVID-19 infection may increase the risk of spreading the same to others at vaccination site. For this reason, infected individuals should defer vaccination for 14 days after symptoms resolution.",
    "Yes, it is advisable to receive complete schedule of COVID vaccine irrespective of past history of infection with COVID-19. This will help in developing a strong immune response against the disease.",
    "The safety and efficacy data from clinical trials of vaccine candidates are examined by Drug regulator of our country before granting the license for the same. Hence, all the COVID-19 vaccines that receive license will have comparable safety and efficacy.However, it must be ensured that the entire schedule of vaccination is completed by only one type of vaccine as different COVID-19 vaccines are not interchangeable.",
    "No, registration of beneficiary is mandatory for vaccination for COVID 19 either online from home or to any of the vaccination centres.",
    "The Photo ID produced at the time of registration must be produced and verified at the time of vaccination.",
    "Yes. Persons with one or more of these comorbid conditions are considered high risk category. They need to get COVID -19 vaccination.",
    "COVID Vaccine are introduced only when the safety is proven. As is true for other vaccines, the common side effects in some individuals could be mild fever, pain, etc. at the site of injection.States have been asked to start making arrangements to deal with any Covid-19 vaccine-related side-effects as one of the measures towards safe vaccine delivery among masses.You can also chat with healthcare workers and get clarifications on the same.",
    "Even after receiving the COVID 19 vaccine, we must continue taking all precautions like use of face cover or masks, hand sanitization and maintain distancing (6 feet or Do Gaj). These behaviours must be followed both during vaccination and in general.",
    "Two doses of vaccine, 28 days apart, need to be taken by an individual to complete the vaccination schedule.",
    "Protective levels of antibodies are generally developed two weeks after receiving the 2nd dose of COVID-19 vaccine.",
  ];

  return List.generate(questions.length, (index) {
    return Item(headerValue: questions[index], expandedValue: answers[index]);
  });
}

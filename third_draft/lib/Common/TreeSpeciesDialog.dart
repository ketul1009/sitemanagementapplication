import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:second_draft/Common/SearchableDropDown.dart';
import '../Constants/GeneralData.dart';
import 'DateAndTimePicker.dart';

enum Species { Tree, Shrubs, Lawn }

class TreeSpeciesDialog extends StatefulWidget{
  final void Function(Map<String, String>) onDataSubmitted;

  const TreeSpeciesDialog({super.key, required this.onDataSubmitted});

  @override
  State<TreeSpeciesDialog> createState() => TreeSpeciesDialogState();

}

class TreeSpeciesDialogState extends State<TreeSpeciesDialog>{
  List<String> speciesList = ["Select a species"];
  String selectedValue = "Select a species";
  String selectedType = "";
  String selectedSpecies = "Select a species";
  String quantityPrompt = "Enter Quantity ";
  String greenZone="";
  String quantity="";
  String area = "";
  String date = "YYYY-MM-DD";
  String alert="";

  final TextEditingController textEditingController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController areaController = TextEditingController();
  final TextEditingController greenZoneController = TextEditingController();

  void _sendDataToParent(Map<String, String> map){
    widget.onDataSubmitted(map);
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedType = category;
      selectedSpecies = "Select a species";
      speciesList = ["Select a species"] + species[category];
    });
  }

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text("GreenZone Number", style: TextStyle(fontSize: 20)),
        SizedBox( width: 150, child: TextField(
          maxLength: 10,
          cursorHeight: 30,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          controller: greenZoneController,
          onChanged: (String newValue){
            setState(() {
              greenZone = newValue;
            });
          },
        ),),
        const SizedBox(height: 10,),
        const Text("Select Species Type", style: TextStyle(fontSize: 20)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio<String>(
              value: 'Tree',
              groupValue: selectedType,
              onChanged: (String? value) {
                setState(() {
                  selectedType = value!;
                });
                _onCategorySelected(value!);
              },
            ),
            const Text('Tree', style: TextStyle(fontSize: 20)),
            Radio<String>(
              value: 'Shrubs',
              groupValue: selectedType,
              onChanged: (String? value) {
                setState(() {
                  selectedType = value!;
                  speciesList=species[selectedType];
                });
                _onCategorySelected(value!);
              },
            ),
            const Text('Shrub', style: TextStyle(fontSize: 20)),
            Radio<String>(
              value: 'Lawn',
              groupValue: selectedType,
              onChanged: (String? value) {
                setState(() {
                  selectedType = value!;
                });
                _onCategorySelected(value!);
              },
            ),
            const Text('Lawn', style: TextStyle(fontSize: 20)),
            Radio<String>(
              value: 'Palm',
              groupValue: selectedType,
              onChanged: (String? value) {
                setState(() {
                  selectedType = value!;
                });
                _onCategorySelected(value!);
              },
            ),
            const Text('Palm', style: TextStyle(fontSize: 20)),
          ],
        ),
        const SizedBox(height: 10,),
        DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Select Species',
            style: TextStyle(
              fontSize: 20,
              color: Theme.of(context).hintColor,
            ),
          ),
          items: speciesList
              .map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ))
              .toList(),
          value: selectedSpecies,
          onChanged: (value) {
            setState(() {
              selectedSpecies=value!;
            });
          },
          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.symmetric(horizontal: 16),
            height: 40,
            width: 300,
          ),
          dropdownStyleData: const DropdownStyleData(
            maxHeight: 200,
          ),
          menuItemStyleData: const MenuItemStyleData(
            height: 40,
          ),
          dropdownSearchData: DropdownSearchData(
            searchController: textEditingController,
            searchInnerWidgetHeight: 50,
            searchInnerWidget: Container(
              height: 50,
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 4,
                right: 8,
                left: 8,
              ),
              child: TextFormField(
                expands: true,
                maxLines: null,
                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  hintText: 'Search for an item...',
                  hintStyle: const TextStyle(fontSize: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
            searchMatchFn: (item, searchValue) {
              return item.value.toString().toLowerCase().contains(searchValue.toLowerCase());
            },
          ),
          //This to clear the search value when you close the menu
          onMenuStateChange: (isOpen) {
            if (!isOpen) {
              textEditingController.clear();
            }
          },
        ),
        const SizedBox(height: 20,),
        Visibility(
          visible: (selectedType!="lawn"),
          child: Column(
              children: [
                const Text("Quantity (number)", style: TextStyle(fontSize: 20)),
                SizedBox( width: 150, child: TextField(
                  maxLength: 10,
                  cursorHeight: 30,
                  style: const TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  controller: quantityController,
                  keyboardType: TextInputType.number,
                  onChanged: (String newValue){
                    setState(() {
                      quantity = newValue;
                    });
                  },
                ),),
              ],
            ),
        ),
        const Text("Area (Sq. meter)", style: TextStyle(fontSize: 20)),
        SizedBox( width: 150, child: TextField(
          maxLength: 10,
          cursorHeight: 30,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
          controller: areaController,
          keyboardType: TextInputType.number,
          onChanged: (String newValue){
            setState(() {
              area = newValue;
            });
          },
        ),),
        DateAndTimePicker(
          title: "Select Plantation Date",
            onDataSubmission: (String selectedDate) {
              setState(() {
                date = selectedDate;
              });
            }
        ),
        Text(alert, style: const TextStyle(color: Colors.red),),
        ElevatedButton(
            onPressed: (){
              if(selectedType.isEmpty || quantity.isEmpty || area.isEmpty || selectedSpecies=="Select a species" || date=="YYYY-MM-DD" || greenZone.isEmpty){
                setState(() {
                  alert="*Please select appropriate values";
                });
              }
              else{
                Map<String, String> map = {
                  "GreenZone" : greenZone,
                  "Type" : selectedType,
                  "Species" : selectedSpecies,
                  "Quantity" : quantity,
                  "Area" : area,
                  "Date" : date
                };
                setState(() {
                  alert="";
                  selectedValue = "Select a species";
                  selectedType = "";
                  selectedSpecies = "Select a species";
                  quantityPrompt = "Enter Quantity ";
                  quantity="";
                  area = "";
                  date = "YYYY-MM-DD";
                });
                textEditingController.clear();
                quantityController.clear();
                areaController.clear();
                _sendDataToParent(map);
              }
            },
            child: const Icon(CupertinoIcons.add)),
      ],
    );
  }
}
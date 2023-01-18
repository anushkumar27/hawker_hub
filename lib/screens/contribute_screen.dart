import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:hawker_hub/screens/hub_location_picker_screen.dart';
import 'package:hawker_hub/utilities/constants.dart';

class ContributeScreen extends StatefulWidget {
  const ContributeScreen({super.key});

  @override
  State<ContributeScreen> createState() => _ContributeScreenState();
}

class _ContributeScreenState extends State<ContributeScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _hubCategoryOptions = ['Food', 'Vegetables', 'Flowers', 'Other'];

  bool _hubNameHasError = false;
  bool _hubDescriptionHasError = false;
  bool _hubCategoryOptionsHasError = false;
  bool _hubCostHasError = false;
  bool _hubAddressHasError = false;
  bool _hubPhoneNumberHasError = false;

  void _onChanged(dynamic val) => debugPrint(val.toString());

  final heightSpacer = const SizedBox(height: 15);
  final List<Widget> _additonalLocationsArray = <Widget>[];
  int _additionalLocationsCount = 0;

  hubRatingBar(context) => FormBuilderRatingBar(
        decoration: const InputDecoration(labelText: 'Hub Rating'),
        name: 'hub_rating',
        wrapAlignment: WrapAlignment.center,
        allowHalfRating: true,
        itemSize: 50.0,
        initialValue: 2.5,
        maxRating: 5.0,
        onChanged: _onChanged,
        unratedColor: Theme.of(context).colorScheme.primary,
        glowColor: Theme.of(context).colorScheme.primary,
      );

  hubImagePicker(context) => FormBuilderImagePicker(
        name: 'hub_photo',
        decoration: const InputDecoration(
          labelText: 'Hub Photo',
        ),
        showDecoration: true,
        maxImages: 1,
        previewAutoSizeWidth: true,
      );

  hubNameTextField(context) => FormBuilderTextField(
        autofocus: true,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: 'hub_name',
        decoration: InputDecoration(
            hintText: "Hub Name",
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: 'Name',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['hub_name']?.reset();
              },
            )),
        onChanged: (val) {
          setState(() {
            _hubNameHasError =
                !(_formKey.currentState?.fields['hub_name']?.validate() ??
                    false);
          });
        },
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.max(70),
        ]),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      );

  hubDescriptionTextField(context) => FormBuilderTextField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: 'hub_description',
        decoration: InputDecoration(
            hintText: "Hub Description",
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: 'Description',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['hub_description']?.reset();
              },
            )),
        onChanged: (val) {
          setState(() {
            _hubDescriptionHasError = !(_formKey
                    .currentState?.fields['hub_description']
                    ?.validate() ??
                false);
          });
        },
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.max(150),
        ]),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
      );

  hubCategoryDropdown(context) => FormBuilderDropdown<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: 'hub_category',
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
          hintText: "Hub Category",
          filled: true,
          fillColor: Colors.white,
          labelText: 'Category',
        ),
        validator:
            FormBuilderValidators.compose([FormBuilderValidators.required()]),
        items: _hubCategoryOptions
            .map((hubCategory) => DropdownMenuItem(
                  alignment: AlignmentDirectional.center,
                  value: hubCategory,
                  child: Text(hubCategory),
                ))
            .toList(),
        onChanged: (val) {
          setState(() {
            _hubCategoryOptionsHasError =
                !(_formKey.currentState?.fields['hub_category']?.validate() ??
                    false);
          });
        },
        valueTransformer: (val) => val?.toString(),
      );

  hubCostTextField(context) => FormBuilderTextField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: 'hub_cost',
        decoration: InputDecoration(
            hintText: "Cost for two (USD)",
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: 'Cost for two (USD)',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['hub_cost']?.reset();
              },
            )),
        onChanged: (val) {
          setState(() {
            _hubCostHasError =
                !(_formKey.currentState?.fields['hub_cost']?.validate() ??
                    false);
          });
        },
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.numeric(),
          FormBuilderValidators.min(1),
        ]),
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
      );

  hubAddressTextField(context, locationIndex) => FormBuilderTextField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: 'hub_address_$locationIndex',
        decoration: InputDecoration(
            hintText: "Hub Address",
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: 'Address',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['hub_address']?.reset();
              },
            )),
        onChanged: (val) {
          setState(() {
            _hubAddressHasError =
                !(_formKey.currentState?.fields['hub_address']?.validate() ??
                    false);
          });
        },
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.max(150),
        ]),
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.next,
      );

  hubAddressLatitude(context, locationIndex) => FormBuilderField(
        name: 'hub_address_lat_$locationIndex',
        enabled: false,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        builder: (FormFieldState<dynamic> field) {
          //Empty widget
          return const SizedBox.shrink();
        },
      );

  hubAddressLongitude(context, locationIndex) => FormBuilderField(
        name: 'hub_address_long_$locationIndex',
        enabled: false,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        builder: (FormFieldState<dynamic> field) {
          //Empty widget
          return const SizedBox.shrink();
        },
      );

  hubPhoneNumberTextField(context, locationIndex) => FormBuilderTextField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: 'hub_phone_number_$locationIndex',
        decoration: InputDecoration(
            hintText: "Hub Phone Number",
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: 'Phone Number',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['hub_phone_number']?.reset();
              },
            )),
        onChanged: (val) {
          setState(() {
            _hubPhoneNumberHasError = !(_formKey
                    .currentState?.fields['hub_phone_number']
                    ?.validate() ??
                false);
          });
        },
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.max(150),
        ]),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
      );

  hubDaysOfOperationCheckBox(context, locationIndex) =>
      FormBuilderCheckboxGroup<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(labelText: 'Days of Operation'),
        name: 'hub_days_of_operation_$locationIndex',
        // initialValue: const ['Dart'],
        options: const [
          FormBuilderFieldOption(value: 'Monday'),
          FormBuilderFieldOption(value: 'Tuesday'),
          FormBuilderFieldOption(value: 'Wednesday'),
          FormBuilderFieldOption(value: 'Thursday'),
          FormBuilderFieldOption(value: 'Friday'),
          FormBuilderFieldOption(value: 'Saturday'),
          FormBuilderFieldOption(value: 'Sunday'),
        ],
        onChanged: _onChanged,
        separator: const VerticalDivider(
          width: 10,
          thickness: 5,
          color: Colors.red,
        ),
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.minLength(1),
        ]),
      );

  hubStartTimePicker(context, locationIndex) => FormBuilderDateTimePicker(
        name: 'hub_start_time_$locationIndex',
        inputType: InputType.time,
        initialTime: const TimeOfDay(hour: 8, minute: 0),
        timePickerInitialEntryMode: TimePickerEntryMode.dial,
        validator:
            FormBuilderValidators.compose([FormBuilderValidators.required()]),
        decoration: InputDecoration(
            hintText: "Start Time",
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: 'Start Time',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['hub_start_time']?.reset();
              },
            )),
      );

  hubEndTimePicker(context, locationIndex) => FormBuilderDateTimePicker(
        name: 'hub_end_time_$locationIndex',
        inputType: InputType.time,
        initialTime: const TimeOfDay(hour: 20, minute: 0),
        timePickerInitialEntryMode: TimePickerEntryMode.dial,
        validator:
            FormBuilderValidators.compose([FormBuilderValidators.required()]),
        decoration: InputDecoration(
            hintText: "End Time",
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: 'End Time',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['hub_end_time']?.reset();
              },
            )),
      );

  hubRemoveAllLocationsButton() {
    if (_additionalLocationsCount > 0) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xff6750a4),
            foregroundColor: Colors.white),
        onPressed: () {
          setState(() {
            _additionalLocationsCount = 0;
            _additonalLocationsArray.clear();
          });
        },
        child: const Text(
          'Remove All Locations',
        ),
      );
    }
    return const SizedBox.shrink();
  }

  submitButton(context) => Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff6750a4),
              foregroundColor: Colors.white),
          onPressed: () {
            debugPrint(_hubAddressHasError.toString());
            debugPrint(_hubCategoryOptions.toString());
            debugPrint(_hubCategoryOptionsHasError.toString());
            debugPrint(_hubCostHasError.toString());
            debugPrint(_hubNameHasError.toString());
            debugPrint(_hubPhoneNumberHasError.toString());
            debugPrint(_hubDescriptionHasError.toString());
            if (_formKey.currentState?.saveAndValidate() ?? false) {
              debugPrint(_formKey.currentState?.value.toString());
            } else {
              debugPrint(_formKey.currentState?.value.toString());
              debugPrint('validation failed');
            }
          },
          child: const Text(
            'Submit',
          ),
        ),
      );

  resetButton(context) => Expanded(
        child: OutlinedButton(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
          onPressed: () {
            _formKey.currentState?.reset();
          },
          // color: Theme.of(context).colorScheme.secondary,
          child: const Text('Reset'),
        ),
      );

  hubAddressMapPicker(context, locationIndex) {
    return OutlinedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HubLocationPickerScreen(
                hubLocationIndex: locationIndex,
                setHubAddressAndGeoLocationCallback:
                    setHubAddressAndGeoLocation),
          ),
        );
      },
      child: const Text(
        'Pick Address on the Map',
      ),
    );
  }

  setHubAddressAndGeoLocation(int hubLocationIndex, String hubAddress,
      dynamic latitude, dynamic longitude) {
    _formKey.currentState!.fields['hub_address_$hubLocationIndex']
        ?.didChange(hubAddress);
    _formKey.currentState!.fields['hub_address_lat_$hubLocationIndex']
        ?.didChange(latitude);
    _formKey.currentState!.fields['hub_address_long_$hubLocationIndex']
        ?.didChange(longitude);
  }

  getHubLocationFields(context, locationIndex) {
    return <Widget>[
      heightSpacer,
      hubAddressTextField(context, locationIndex),
      hubAddressLatitude(context, locationIndex),
      hubAddressLongitude(context, locationIndex),
      hubAddressMapPicker(context, locationIndex),
      heightSpacer,
      hubPhoneNumberTextField(context, locationIndex),
      hubDaysOfOperationCheckBox(context, locationIndex),
      heightSpacer,
      hubStartTimePicker(context, locationIndex),
      heightSpacer,
      hubEndTimePicker(context, locationIndex),
      heightSpacer
    ];
  }

  _addAdditionalAddressButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xff6750a4),
          foregroundColor: Colors.white),
      onPressed: () {
        setState(() {
          // Create a new location field
          List<Widget> hubLocationFields =
              getHubLocationFields(context, _additionalLocationsCount++);
          _additonalLocationsArray
              .add(Text("Additional Location : $_additionalLocationsCount"));
          _additonalLocationsArray.add(heightSpacer);
          for (Widget widget in hubLocationFields) {
            _additonalLocationsArray.add(widget);
          }
          _additonalLocationsArray.add(heightSpacer);
        });
      },
      child: const Text(
        'Add Location',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SizedBox.expand(
            child: Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Contribute")),
        backgroundColor: Constants.primarySurfaceColor,
      ),
      body: Container(
          padding: const EdgeInsets.all(20),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                FormBuilder(
                  key: _formKey,
                  // enabled: false,
                  onChanged: () {
                    _formKey.currentState!.save();
                    debugPrint(_formKey.currentState!.value.toString());
                  },
                  autovalidateMode: AutovalidateMode.disabled,
                  skipDisabled: true,
                  child: Column(
                    children: <Widget>[
                      heightSpacer,
                      hubRatingBar(context),
                      hubImagePicker(context),
                      heightSpacer,
                      hubNameTextField(context),
                      heightSpacer,
                      hubDescriptionTextField(context),
                      heightSpacer,
                      hubCategoryDropdown(context),
                      heightSpacer,
                      const Text("Locations"),
                      ...getHubLocationFields(context, 0),
                      _addAdditionalAddressButton(context),
                      heightSpacer,
                      ..._additonalLocationsArray,
                      hubRemoveAllLocationsButton(),
                    ],
                  ),
                ),
                heightSpacer,
                Divider(color: Theme.of(context).colorScheme.primary),
                Row(
                  children: <Widget>[
                    resetButton(context),
                    const SizedBox(width: 20),
                    submitButton(context),
                  ],
                ),
              ],
            ),
          )),
    )));
  }
}

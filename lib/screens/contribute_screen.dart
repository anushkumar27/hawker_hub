import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_phone_field/form_builder_phone_field.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:form_builder_extra_fields/form_builder_extra_fields.dart';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:hawker_hub/models/hub.dart';
import 'package:hawker_hub/providers/hub_provider.dart';
import 'package:hawker_hub/screens/hub_location_picker_screen.dart';
import 'package:hawker_hub/services/api_response.dart';
import 'package:hawker_hub/utilities/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ContributeScreen extends StatefulWidget {
  const ContributeScreen({super.key});

  @override
  State<ContributeScreen> createState() => _ContributeScreenState();
}

class _ContributeScreenState extends State<ContributeScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final _hubCategoryOptions = ['Food', 'Vegetables', 'Flowers', 'Other'];
  final heightSpacer = const SizedBox(height: 15);
  final List<Widget> _additonalLocationsArray = <Widget>[];
  // Index 0 is mandatory and hence starting additional locations count from 1
  int _additionalLocationsCount = 1;
  var uuidGenerator = const Uuid();

  hubRatingBar(context) => FormBuilderRatingBar(
        decoration: const InputDecoration(labelText: 'Hub Rating'),
        name: 'hub_rating',
        wrapAlignment: WrapAlignment.center,
        allowHalfRating: true,
        itemSize: 50.0,
        initialValue: 2.5,
        maxRating: 5.0,
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
        validator:
            FormBuilderValidators.compose([FormBuilderValidators.required()]),
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
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.max(150),
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
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
          FormBuilderValidators.max(300),
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
        valueTransformer: (val) => val?.toString(),
      );

  hubCostTextField(context) => FormBuilderTextField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: 'hub_cost_for_two',
        decoration: InputDecoration(
            hintText: "Cost for two (USD)",
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: 'Cost for two (USD)',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['hub_cost_for_two']?.reset();
              },
            )),
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
        readOnly: true,
        name: 'hub_address_$locationIndex',
        key: Key('hub_address_$locationIndex'),
        decoration: InputDecoration(
            hintText: "Pick an address (Read-only)",
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: 'Address',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['hub_address_$locationIndex']
                    ?.reset();
              },
            )),
        validator:
            FormBuilderValidators.compose([FormBuilderValidators.required()]),
        keyboardType: TextInputType.streetAddress,
        textInputAction: TextInputAction.next,
      );

  hubAddressLatitude(context, locationIndex) => FormBuilderField(
        name: 'hub_address_lat_$locationIndex',
        key: Key('hub_address_lat_$locationIndex'),
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
        key: Key('hub_address_long_$locationIndex'),
        enabled: false,
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.required(),
        ]),
        builder: (FormFieldState<dynamic> field) {
          //Empty widget
          return const SizedBox.shrink();
        },
      );

  hubPhoneNumberTextField(context, locationIndex) => FormBuilderPhoneField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        name: 'hub_phone_number_$locationIndex',
        key: Key('hub_phone_number_$locationIndex'),
        decoration: InputDecoration(
            hintText: "Hub Phone Number",
            filled: true,
            fillColor: Colors.white,
            border: const OutlineInputBorder(),
            labelText: 'Phone Number',
            suffixIcon: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                _formKey.currentState!.fields['hub_phone_number_$locationIndex']
                    ?.reset();
              },
            )),
        priorityListByIsoCode: const ['US'],
        validator: FormBuilderValidators.compose([
          FormBuilderValidators.numeric(),
          FormBuilderValidators.required(),
        ]),
        keyboardType: TextInputType.phone,
        textInputAction: TextInputAction.next,
      );

  hubDaysOfOperationCheckBox(context, locationIndex) =>
      FormBuilderCheckboxGroup<String>(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: const InputDecoration(labelText: 'Days of Operation'),
        name: 'hub_days_of_operation_$locationIndex',
        key: Key('hub_days_of_operation_$locationIndex'),
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
      key: Key('hub_start_time_$locationIndex'),
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
              _formKey.currentState!.fields['hub_start_time_$locationIndex']
                  ?.reset();
            },
          )));

  hubEndTimePicker(context, locationIndex) => FormBuilderDateTimePicker(
      name: 'hub_end_time_$locationIndex',
      key: Key('hub_end_time_$locationIndex'),
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
              _formKey.currentState!.fields['hub_end_time_$locationIndex']
                  ?.reset();
            },
          )));

  hubRemoveAllLocationsButton() {
    if (_additionalLocationsCount > 1) {
      return OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xff6750a4),
            foregroundColor: Colors.white),
        onPressed: () {
          setState(() {
            _additionalLocationsCount = 1;
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
            if (_formKey.currentState?.saveAndValidate() ?? false) {
              debugPrint(_formKey.currentState?.value.toString());

              List<HubLocation> newHubLocations = [];

              for (int currIndex = 0;
                  currIndex < _additionalLocationsCount;
                  currIndex++) {
                String? hubStartTime = _formKey
                    .currentState?.fields['hub_start_time_$currIndex']?.value
                    .toString()
                    .split(" ")[1]
                    .substring(0, 5);
                String? hubEndTime = _formKey
                    .currentState?.fields['hub_end_time_$currIndex']?.value
                    .toString()
                    .split(" ")[1]
                    .substring(0, 5);

                HubLocation newHubLocationDetails = HubLocation(
                    hubAddress: _formKey
                        .currentState?.fields['hub_address_$currIndex']?.value,
                    hubLatitude: _formKey.currentState
                        ?.fields['hub_address_lat_$currIndex']?.value,
                    hubLongitude: _formKey.currentState
                        ?.fields['hub_address_long_$currIndex']?.value,
                    hubPhoneNumber: _formKey.currentState
                        ?.fields['hub_phone_number_$currIndex']?.value,
                    hubDaysOfOperation: _formKey.currentState
                        ?.fields['hub_days_of_operation_$currIndex']?.value,
                    hubStartTime: hubStartTime!,
                    hubEndTime: hubEndTime!);

                newHubLocations.add(newHubLocationDetails);
              }

              Hub newHubDetails = Hub(
                  hubId: uuidGenerator.v4(),
                  hubCategory:
                      _formKey.currentState?.fields['hub_category']?.value,
                  hubRating: _formKey.currentState?.fields['hub_rating']?.value
                      .toDouble(),
                  hubCostForTwo:
                      _formKey.currentState?.fields['hub_cost_for_two']?.value,
                  hubDescription:
                      _formKey.currentState?.fields['hub_description']?.value,
                  hubName: _formKey.currentState?.fields['hub_name']?.value,
                  hubLocations: newHubLocations,
                  hubPhoto: 's3_url');

              // Only one image
              XFile hubPhoto =
                  _formKey.currentState?.fields['hub_photo']?.value[0];

              // Insert hub
              Provider.of<HubProvider>(context, listen: false)
                  .insertHub(newHubDetails, hubPhoto);
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
              getHubLocationFields(context, _additionalLocationsCount);
          _additonalLocationsArray
              .add(Text("Additional Location : $_additionalLocationsCount"));
          _additonalLocationsArray.add(heightSpacer);
          for (Widget widget in hubLocationFields) {
            _additonalLocationsArray.add(widget);
          }
          _additonalLocationsArray.add(heightSpacer);

          _additionalLocationsCount++;
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
                    // debugPrint(_formKey.currentState!.value.toString());
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
                      hubCostTextField(context),
                      heightSpacer,
                      const Text("Locations"),
                      ...getHubLocationFields(context, 0),
                      _addAdditionalAddressButton(context),
                      heightSpacer,
                      ..._additonalLocationsArray,
                      hubRemoveAllLocationsButton(),
                      Consumer<HubProvider>(
                          builder: (context, hubProvider, child) =>
                              showProgressMessage(
                                  context, hubProvider.insertHubsResponse)),
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

  showProgressMessage(
      BuildContext context, ApiResponse<dynamic>? insertHubsResponse) {
    if (insertHubsResponse == null) {
      return Column();
    }
    switch (insertHubsResponse.requestStatus) {
      case RequestStatus.loading:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text("Thanks for your contribution. Adding the Hub..."),
          ],
        );
      case RequestStatus.completed:
        Future.delayed(const Duration(milliseconds: 5000), () {
          Provider.of<HubProvider>(context, listen: false).resetResponses();
          Navigator.pop(context);
        });
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            SizedBox(height: 20),
            Text("Hub added Sucessfully!"),
            SizedBox(height: 20),
            CircularProgressIndicator(),
            SizedBox(height: 10),
            Text("Redirecting in 5 seconds..."),
          ],
        );
      case RequestStatus.error:
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text('There was an error while adding Hub. Please re-submit'),
            const SizedBox(height: 20),
            Text(insertHubsResponse.statusMessage),
          ],
        );
      default:
        return Column();
    }
  }
}

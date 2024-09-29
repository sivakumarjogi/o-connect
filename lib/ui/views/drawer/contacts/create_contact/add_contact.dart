import 'dart:io';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:o_connect/core/models/response_models/get_all_groups_response_model/get_group_details_by_group_id_response_model.dart';
import 'package:o_connect/core/screen_configs.dart';
import 'package:o_connect/ui/common_calender.dart';
import 'package:o_connect/ui/utils/base_urls.dart';
import 'package:o_connect/ui/utils/buttons_helper/custom_botton.dart';
import 'package:o_connect/ui/utils/colors/colors.dart';
import 'package:o_connect/ui/utils/common_app_bar/image_picker_bottombar.dart';
import 'package:o_connect/ui/utils/constant_strings.dart';
import 'package:o_connect/ui/utils/images/images.dart';
import 'package:o_connect/ui/utils/network_image_helpers/cached_image_validation.dart';
import 'package:o_connect/ui/utils/textfield_helper/app_fonts.dart';
import 'package:o_connect/ui/utils/textfield_helper/common_textfield.dart';
import 'package:o_connect/ui/utils/textfield_helper/textFieldTexts.dart';
import 'package:o_connect/ui/views/authentication/form_validations.dart';
import 'package:o_connect/ui/views/meeting/utils/string_extension.dart';
import 'package:provider/provider.dart';
import '../../../../../core/models/create_webinar_model/get_contact_model.dart';
import '../../../../../core/providers/create_contact_provider.dart';

class AddContactPage extends StatefulWidget {
  const AddContactPage({this.isEdit = false, this.index, this.contactData, super.key});

  final bool isEdit;
  final int? index;
  final AllContactsModelDataRecord? contactData;

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  late CreateContactProvider createContactProvider;
  final _addContactFormKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController jobTitleController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController oMailController = TextEditingController();
  TextEditingController alternateEmailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController countryCodeController = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController dateOfBirthController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createContactProvider = Provider.of<CreateContactProvider>(context, listen: false);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      createContactProvider.getCountries(
          countryCode: widget.isEdit && widget.contactData!.countryId != null ? widget.contactData!.countryId.toString() : null,
          isEdit: widget.isEdit && widget.contactData!.countryId != null,
          isFromInitState: true);
    });
    if (widget.isEdit) {
      createContactProvider.editContactPic = widget.contactData!.contactPic;

      updateValuesForEdit(
        country: widget.contactData!.countryName ?? "",
        contactData: widget.contactData!,
      );
    }
  }

  updateValuesForEdit({String? country, required AllContactsModelDataRecord contactData}) {
    firstNameController.text = contactData.firstName ?? "";
    lastNameController.text = contactData.lastName ?? "";
    companyNameController.text = contactData.companyName ?? "";
    jobTitleController.text = contactData.jobTitle ?? "";
    phoneController.text = contactData.contactNumber ?? "";
    oMailController.text = contactData.omailEmailId ?? "";
    alternateEmailController.text = contactData.alternateEmailId ?? "";
    addressController.text = contactData.address ?? "";
    countryCodeController.text = contactData.countryCallCode ?? "";
    zipCodeController.text = contactData.zipcode ?? "";
    dateOfBirthController.text = contactData.dateOfBirth ?? "";
    createContactProvider.changeCountry = country!;
  }

  @override
  void dispose() {
    disposeControllers();
    super.dispose();
  }

  void disposeControllers() {
    firstNameController.dispose();
    lastNameController.dispose();
    companyNameController.dispose();
    jobTitleController.dispose();
    phoneController.dispose();
    oMailController.dispose();
    alternateEmailController.dispose();
    addressController.dispose();
    countryCodeController.dispose();
    zipCodeController.dispose();
    dateOfBirthController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        createContactProvider.clearTempImage(isEdit: widget.isEdit);
        return true;
      },
      child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).cardColor,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  createContactProvider.clearTempImage(isEdit: widget.isEdit);
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  size: 15,
                  color: Theme.of(context).hintColor.withOpacity(0.5),
                )),
            title: Text(
              widget.isEdit == false ? "Add Contact" : "Edit Contact",
              style: w500_14Poppins(color: Theme.of(context).primaryColorLight),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(child: Consumer<CreateContactProvider>(builder: (context, createContactProvider, child) {
              return Form(
                key: _addContactFormKey,
                child: Padding(
                    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.sp),
                      child: Column(children: [
                        height20,

                        /// Edit Image
                        createContactProvider.imageFile == null
                            ? widget.isEdit
                                ? Stack(
                                    children: [
                                      Container(
                                        height: 120.h,
                                        width: 120.w,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8.r), color: Theme.of(context).cardColor),
                                        child: ImageServiceWidget(
                                          networkImgUrl: "${BaseUrls.imageUrl}${createContactProvider.suggestedContactProfile ?? createContactProvider.editContactPic}",
                                        ),
                                      ),
                                      // Align(
                                      //   alignment: Alignment.topRight,
                                      //   child: Container(
                                      //     width: 35.w,
                                      //     height: 35.w,
                                      //     margin: EdgeInsets.only(right: 10.w, top: 10.h),
                                      //     decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(8.r)),
                                      //     child: GestureDetector(
                                      //       child: Icon(
                                      //         Icons.camera_alt_rounded,
                                      //         size: 20.sp,
                                      //         color: Colors.blue,
                                      //       ),
                                      //       onTap: () async {
                                      //         await ImagePickerService.imagePickerBottomSheet(context).then((value) {
                                      //           print("the image name $value");
                                      //           if (value != null) {
                                      //             print("the image $value");
                                      //             createContactProvider.updateImagePickerFile(value);
                                      //           }
                                      //         });
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                      ////del photo
                                      // widget.contactData!.contactPic != null && widget.contactData!.contactPic!.isNotEmpty
                                      //     ? Align(
                                      //         alignment: Alignment.topLeft,
                                      //         child: Padding(
                                      //           padding: const EdgeInsets.only(left: 8),
                                      //           child: Container(
                                      //             width: 35.w,
                                      //             height: 35.w,
                                      //             margin: EdgeInsets.only(right: 10.w, top: 10.h),
                                      //             decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(8.r)),
                                      //             child: GestureDetector(
                                      //               child: Icon(
                                      //                 Icons.delete,
                                      //                 size: 20.sp,
                                      //                 color: Colors.blue,
                                      //               ),
                                      //               onTap: () async {
                                      //                 widget.contactData!.contactPic = null;
                                      //                 if (_addContactFormKey.currentState!.validate()) {
                                      //                   // createContactProvider.editContactPic = null;

                                      //                   await createContactProvider.createContact(
                                      //                     context: context,
                                      //                     contactPic: createContactProvider.imageFile,
                                      //                     dbContact: widget.contactData != null ? widget.contactData!.contactPic : "",
                                      //                     ignoreImage: createContactProvider.imageFile != null ? false : true,
                                      //                     isEdit: widget.isEdit,
                                      //                     data: getJsonData,
                                      //                   );
                                      //                   Navigator.pushReplacementNamed(context, RoutesManager.allContacts);
                                      //                 }
                                      //               },
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       )
                                      //     : const SizedBox(),
                                      ///////del photo
                                    ],
                                  )

                                /// Image Container to select image
                                : GestureDetector(
                                    onTap: () async {
                                      await ImagePickerService.imagePickerBottomSheet(context).then((value) {
                                        print("the image name $value");
                                        if (value != null) {
                                          print("the image $value");
                                          createContactProvider.updateImagePickerFile(value);
                                        }
                                      });
                                    },
                                    child: Container(
                                      height: 120.h,
                                      width: 120.w,
                                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.r), color: Theme.of(context).cardColor),

                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SvgPicture.asset(AppImages.noProfileIcon),
                                      ), // strokeWidth: 1,
                                      // dashPattern: const [8, 4],
                                      // borderType: BorderType.RRect,
                                      // color: Theme.of(context).disabledColor.withOpacity(0.5),
                                      // radius: Radius.circular(1.r),
                                    ),
                                  )
                            : GestureDetector(
                                onTap: () async {
                                  await ImagePickerService.imagePickerBottomSheet(context).then((value) {
                                    if (value != null) {
                                      createContactProvider.updateImagePickerFile(value);
                                    }
                                  });
                                },
                                child: Container(
                                  height: 120.h,
                                  width: 120.w,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      image: DecorationImage(image: FileImage(File(createContactProvider.imageFile!.path)), fit: BoxFit.fill),
                                      color: AppColors.whiteColor),
                                ),
                              ),
                        height10,
                        GestureDetector(
                          onTap: () async {
                            await ImagePickerService.imagePickerBottomSheet(context).then((value) {
                              print("the image name $value");
                              if (value != null) {
                                print("the image $value");
                                createContactProvider.updateImagePickerFile(value);
                              }
                            });
                          },
                          child: Text(
                            widget.isEdit && (createContactProvider.imageFile != null || (widget.contactData!.contactPic != null && widget.contactData!.contactPic != ""))
                                ? "Change Photo"
                                : "Add Photo",
                            style: w400_14Poppins(color: AppColors.mainBlueColor),
                          ),
                        ),
                        height20,
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).cardColor),
                              child: Padding(
                                padding: EdgeInsets.all(12.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ConstantsStrings.contactInfo,
                                      style: w500_14Poppins(color: Theme.of(context).hintColor),
                                    ),
                                    height5,

                                    /// First Name
                                    const TextFieldTexts(name: ConstantsStrings.firstName, isRequired: true),
                                    CommonTextFormField(
                                      fillColor: Theme.of(context).cardColor,
                                      hintStyle: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                      controller: firstNameController,
                                      hintText: ConstantsStrings.enterFirstName,
                                      borderColor: Theme.of(context).primaryColorLight,
                                      inputFormatters: [CustomTextInputFormatterRegistrationMail()],
                                      keyboardType: TextInputType.name,
                                      maxLength: 50,
                                      validator: (value, text) {
                                        return FormValidations.requiredFieldValidation(value, "First name");
                                      },
                                    ),
                                    height5,

                                    /// Last Name
                                    const TextFieldTexts(name: ConstantsStrings.lastName, isRequired: true),
                                    CommonTextFormField(
                                      fillColor: Theme.of(context).cardColor,
                                      borderColor: Theme.of(context).primaryColorLight,
                                      hintStyle: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                      controller: lastNameController,
                                      hintText: ConstantsStrings.enterLastName,
                                      inputFormatters: [CustomTextInputFormatterRegistrationMail()],
                                      maxLength: 50,
                                      validator: (value, text) {
                                        return FormValidations.requiredFieldValidation(value, "Last name");
                                      },
                                    ),
                                    height5,

                                    /// Company Name
                                    const TextFieldTexts(name: ConstantsStrings.companyName),
                                    CommonTextFormField(
                                      fillColor: Theme.of(context).cardColor,
                                      hintStyle: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                      controller: companyNameController,
                                      borderColor: Theme.of(context).primaryColorLight,
                                      inputFormatters: [CustomTextInputFormatterRegistrationMail()],
                                      hintText: ConstantsStrings.enterCompanyName,
                                      maxLength: 100,
                                      validator: (value, String? f) {
                                        // if (RegExp(r'[^a-zA-Z0-9\.]').hasMatch(value ?? '')) {
                                        //   return "Special characters not allowed,Only (.) (-) (_) allowed";
                                        // }
                                      },
                                    ),
                                    height5,

                                    /// Job Title
                                    const TextFieldTexts(name: ConstantsStrings.jobTitle),
                                    CommonTextFormField(
                                      fillColor: Theme.of(context).cardColor,
                                      hintStyle: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                      enableBorder: false,
                                      borderColor: Theme.of(context).primaryColorLight,
                                      controller: jobTitleController,
                                      hintText: ConstantsStrings.enterJobTitle,
                                    ),
                                    height5,

                                    /// DOB
                                    const TextFieldTexts(name: ConstantsStrings.dateOfBirth),
                                    Consumer<CreateContactProvider>(builder: (context, provider, child) {
                                      return CommonTextFormField(
                                        fillColor: Theme.of(context).cardColor,
                                        readOnly: true,
                                        hintStyle: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                        enableBorder: false,
                                        borderColor: Theme.of(context).primaryColorLight,
                                        controller: dateOfBirthController,
                                        hintText: "DD-MM-YYYY",
                                        suffixIcon: IconButton(
                                            onPressed: () async {
                                              DateTime? pickedDate = await commonCalender(context);
                                              if (pickedDate != null) {
                                                dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                                              }
                                            },
                                            icon: SvgPicture.asset(AppImages.moreCalendarIcon)),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ),
                            height10,
                            Container(
                              decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Theme.of(context).cardColor),
                              child: Padding(
                                padding: EdgeInsets.all(12.sp),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ConstantsStrings.personalInfo,
                                      style: w500_14Poppins(color: Theme.of(context).hintColor),
                                    ),
                                    height5,

                                    /// OMail Address
                                    const TextFieldTexts(name: ConstantsStrings.omailAddress, isRequired: false),
                                    CommonTextFormField(
                                      borderColor: Theme.of(context).primaryColorLight.withOpacity(0.5),
                                      readOnly: true, //widget.isEdit,
                                      fillColor: Theme.of(context).cardColor,
                                      hintStyle: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                      controller: oMailController,
                                      hintText: ConstantsStrings.enterOmailAddress,
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                    height5,

                                    /// Alternate Mail
                                    const TextFieldTexts(name: ConstantsStrings.alternetMail, isRequired: true),
                                    CommonTextFormField(
                                      borderColor: Theme.of(context).primaryColorLight,
                                      fillColor: Theme.of(context).cardColor,
                                      hintStyle: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                      controller: alternateEmailController,
                                      hintText: ConstantsStrings.enterAlternateEmail,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: FormValidations.emailValidation,
                                      onChanged: (value) async {
                                        if (value.isNotEmpty && value.isEmailValid) {
                                          print("object");
                                          Contact? contact = await createContactProvider.getEmailSuggestions(value);
                                          if (contact != null) {
                                            firstNameController.text = contact.firstName ?? "";
                                            lastNameController.text = contact.lastName ?? "";
                                            companyNameController.text = contact.companyName ?? "";
                                            jobTitleController.text = contact.jobTitle ?? "";
                                            phoneController.text = contact.contactNumber ?? "";
                                            oMailController.text = contact.omailEmailId ?? "";
                                            addressController.text = contact.address ?? "";
                                            countryCodeController.text = contact.countryId.toString();
                                            zipCodeController.text = (contact.zipcode ?? "").toString();
                                            dateOfBirthController.text = DateFormat('yyyy-MM-dd').format(contact.dateOfBirth);

                                            setState(() {});
                                          }
                                        }
                                      },
                                    ),
                                    height5,

                                    /// Address
                                    const TextFieldTexts(name: ConstantsStrings.address, isRequired: false),
                                    CommonTextFormField(
                                      fillColor: Theme.of(context).cardColor,
                                      hintStyle: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                      maxLines: 4,
                                      borderColor: Theme.of(context).primaryColorLight,
                                      controller: addressController,
                                      hintText: ConstantsStrings.enterAddress,
                                      keyboardType: TextInputType.streetAddress,
                                    ),
                                    height5,

                                    /// Country
                                    const TextFieldTexts(name: ConstantsStrings.country, isRequired: true),
                                    Consumer<CreateContactProvider>(builder: (context, createContactProvider, child) {
                                      return DropdownButtonFormField2(
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.zero,
                                          errorStyle: w500_12Poppins(
                                            color: Colors.red,
                                          ),
                                          border: InputBorder.none, // Remove the underline
                                          // Add a label if needed
                                        ),
                                        style: TextStyle(color: Theme.of(context).hintColor),
                                        dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(color: Theme.of(context).primaryColor)),
                                        buttonStyleData: ButtonStyleData(
                                            decoration: BoxDecoration(
                                                color: Theme.of(context).cardColor,
                                                borderRadius: BorderRadius.circular(5.r),
                                                border: Border.all(color: Theme.of(context).primaryColorDark, width: 0.2))),
                                        isExpanded: true,

                                        isDense: false,
                                        iconStyleData: IconStyleData(
                                          icon: Padding(
                                            padding: EdgeInsets.all(6.0.sp),
                                            child: Icon(Icons.expand_more, color: Theme.of(context).primaryColorLight),
                                          ),
                                          iconSize: 30.sp,
                                        ),
                                        // underline: const SizedBox.shrink(),
                                        hint: Text(
                                          "Select Country",
                                          style: TextStyle(color: Theme.of(context).primaryColorLight),
                                        ),

                                        disabledHint: Padding(
                                          padding: EdgeInsets.all(5.0.sp),
                                          child: Text("Select Country", style: w400_13Poppins(color: Theme.of(context).primaryColorLight)),
                                        ),
                                        validator: (val) {
                                          if (val == "Select Country") {
                                            return "Please select a country";
                                          }
                                          return null;
                                        },
                                        autovalidateMode: AutovalidateMode.onUserInteraction,
                                        value: createContactProvider.selectedCountry.isEmpty || createContactProvider.countriesList.isEmpty
                                            ? "Select Country"
                                            : createContactProvider.selectedCountry /* == "Select Country" ? createContactProvider.countriesList.first.name : createContactProvider.selectedCountry*/,
                                        items: [
                                          DropdownMenuItem<String>(
                                            value: "Select Country",
                                            child: Text(
                                              "Select Country",
                                              style: TextStyle(color: Theme.of(context).primaryColorLight),
                                            ),
                                          ),
                                          ...createContactProvider.countriesList.map(
                                            (value) {
                                              return DropdownMenuItem<String>(
                                                value: (value.name.isEmpty) ? "Select Country" : value.name,
                                                child: Text(
                                                  (value.name.isEmpty) ? "Select Country" : value.name,
                                                ),
                                              );
                                            },
                                          ).toList()
                                        ],
                                        onChanged: (value) {
                                          createContactProvider.updateDropdownValue(countryName: value!);
                                        },
                                      );
                                    }),

                                    height5,

                                    /// State
                                    if (createContactProvider.statesList.isNotEmpty) ...[
                                      const TextFieldTexts(name: ConstantsStrings.state, isRequired: false),
                                      DropdownButtonFormField2(
                                        decoration: const InputDecoration(contentPadding: EdgeInsets.zero, border: InputBorder.none),
                                        isDense: false,
                                        dropdownStyleData: DropdownStyleData(decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor)),
                                        buttonStyleData: ButtonStyleData(
                                          decoration: BoxDecoration(
                                              color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(5.r), border: Border.all(color: Theme.of(context).primaryColorDark, width: 0.2)),
                                        ),
                                        style: TextStyle(color: Theme.of(context).hintColor),
                                        isExpanded: true,
                                        iconStyleData: IconStyleData(
                                          icon: Padding(
                                            padding: EdgeInsets.all(6.0.sp),
                                            child: Icon(Icons.expand_more, size: 25.sp, color: Theme.of(context).primaryColorLight),
                                          ),
                                          iconSize: 30.sp,
                                        ),
                                        // underline: const SizedBox.shrink(),

                                        disabledHint: Padding(padding: const EdgeInsets.all(5.0), child: Text("Select State", style: w400_13Poppins(color: Theme.of(context).disabledColor))),
                                        value: createContactProvider.selectedState,
                                        items: [
                                          const DropdownMenuItem<String>(
                                            value: "Select State",
                                            child: Text(
                                              "Select State",
                                            ),
                                          ),
                                          ...createContactProvider.statesList.map(
                                            (value) {
                                              return DropdownMenuItem<String>(
                                                value: value.name,
                                                child: Text(value.name),
                                              );
                                            },
                                          ).toList()
                                        ],
                                        onChanged: (value) {
                                          createContactProvider.updateStateValue(updatedValue: value!);
                                        },
                                      ),
                                    ],
                                    height5,
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const TextFieldTexts(name: ConstantsStrings.countryCode),
                                            Container(
                                              height: 35.h,
                                              width: ScreenConfig.width * 0.2,
                                              decoration: BoxDecoration(
                                                  color: Theme.of(context).cardColor,
                                                  borderRadius: BorderRadius.circular(5.r),
                                                  border: Border.all(color: Theme.of(context).primaryColorDark, width: 0.2)),
                                              child: Center(
                                                child: Text(
                                                  "+${createContactProvider.countryCode}",
                                                  style: w500_14Poppins(color: Theme.of(context).hintColor),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        width10,

                                        /// Phone Number
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const TextFieldTexts(name: ConstantsStrings.phoneNumber, isRequired: true),

                                              /// Phone number field
                                              Container(
                                                  height: 35.h,
                                                  decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(5.r)),
                                                  child: CommonTextFormField(
                                                      maxLength: 10,
                                                      hintText: "Enter Phone Number",
                                                      hintStyle: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                                      fillColor: Theme.of(context).cardColor,
                                                      borderColor: Theme.of(context).primaryColorLight,
                                                      keyboardType: TextInputType.phone,
                                                      inputAction: TextInputAction.done,
                                                      labelStyle: w500_14Poppins(color: Theme.of(context).disabledColor),
                                                      controller: phoneController)),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    height5,

                                    /// Zip Code
                                    const TextFieldTexts(name: ConstantsStrings.zipCode, isRequired: false),
                                    CommonTextFormField(
                                      fillColor: Theme.of(context).cardColor,
                                      hintStyle: w400_13Poppins(color: Theme.of(context).primaryColorLight),
                                      controller: zipCodeController,
                                      borderColor: Theme.of(context).primaryColorLight,
                                      hintText: ConstantsStrings.enterPostalCode,
                                      keyboardType: TextInputType.number,
                                    ),
                                    height5,
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        height10,
                        Row(
                          children: [
                            width10,

                            /// Cancel Button
                            CustomButton(
                              buttonTextStyle: w400_15Poppins(
                                color: Theme.of(context).hintColor,
                              ),
                              width: MediaQuery.of(context).size.width * 0.45,
                              buttonText: ConstantsStrings.cancel,
                              textColor: Theme.of(context).hintColor,
                              // borderColor: AppColors.customButtonBlueColor,
                              buttonColor: AppColors.customButtonBlueColor.withOpacity(0.1),
                              onTap: () {
                                createContactProvider.clearTempImage(isEdit: widget.isEdit);
                                Navigator.pop(context);
                              },
                            ),
                            width10,

                            /// Save Button
                            CustomButton(
                              width: ScreenConfig.width * 0.45,
                              buttonText: widget.isEdit ? "Update" : ConstantsStrings.save,
                              textColor: AppColors.whiteColor,
                              buttonColor: AppColors.customButtonBlueColor,
                              onTap: () async {
                                if (_addContactFormKey.currentState!.validate()) {
                                  await createContactProvider.createContact(
                                    data: getJsonData,
                                    context: context,
                                    contactPic: createContactProvider.imageFile,
                                    dbContact: widget.contactData != null ? widget.contactData!.contactPic : "",
                                    ignoreImage: createContactProvider.imageFile != null ? false : true,
                                    isEdit: widget.isEdit,
                                  );
                                  // Navigator.pushReplacementNamed(context, RoutesManager.allContacts);
                                }
                                ;
                              },
                            )
                          ],
                        )
                      ]),
                    )),
              );
            })),
          )),
    );
  }

  Map get getJsonData {
    Map<String, dynamic> data = {
      "contactId": widget.contactData != null ? widget.contactData!.contactId ?? 0 : 0,
      "firstName": firstNameController.text,
      "lastName": lastNameController.text,
      "companyName": companyNameController.text,
      "jobTitle": jobTitleController.text,
      "dateOfBirth": dateOfBirthController.text,
      "countryCallCode": countryCodeController.text,
      "countryId": createContactProvider.countryId,
      "omailEmailId": oMailController.text,
      "contactNumber": phoneController.text,
      "stateId": createContactProvider.selectedState == "Select State" ? "" : createContactProvider.stateId ?? 4009,
      "alternateEmailId": alternateEmailController.text,
      "zipcode": zipCodeController.text,
      "address": addressController.text,
      "contactPic": (createContactProvider.imageFile != null ? false : true) ? (widget.contactData != null ? widget.contactData!.contactPic : "") : "",
      "favStatus": 0,
      "badgeId": 4
    };
    return data;
  }
}

class CustomTextInputFormatterRegistrationMail extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isEmpty) {
      return newValue;
    }

    String filteredValue = newValue.text.replaceAll(
      RegExp(r'[^\w.\-@]'), // Allow any word character, ., -, and @
      '',
    );

    List<String> disallowedSequences = ['..', '.-', '._', '-_', '@-', '@_', '-@', '_@', '.@', '-.', '_-', '_.', '@.'];

    for (String sequence in disallowedSequences) {
      if (filteredValue.contains(sequence)) {
        return oldValue;
      }
    }

    int underscoreCount = 0;
    int hyphenCount = 0;
    int atCount = 0;
    int dotCount = 0;

    for (int i = 0; i < filteredValue.length; i++) {
      if (filteredValue[i] == '_') {
        underscoreCount++;
        hyphenCount = 0;
        atCount = 0;
        dotCount = 0;
      } else if (filteredValue[i] == '-') {
        hyphenCount++;
        underscoreCount = 0;
        atCount = 0;
        dotCount = 0;
      } else if (filteredValue[i] == '@') {
        atCount++;
        underscoreCount = 0;
        hyphenCount = 0;
        dotCount = 0;
      } else if (filteredValue[i] == '.') {
        dotCount++;
        underscoreCount = 0;
        hyphenCount = 0;
        atCount = 0;
      }

      if (underscoreCount > 1 || hyphenCount > 1 || atCount > 1 || dotCount > 2) {
        return oldValue;
      }
    }

    // Check if underscore and hyphen count is restricted to one each
    if (underscoreCount > 1 || hyphenCount > 1) {
      return oldValue;
    }

    int dotCountBeforeAt = 0;
    int dotCountAfterAt = 0;

    int atIndex = filteredValue.indexOf('@');
    if (atIndex != -1) {
      String beforeAt = filteredValue.substring(0, atIndex);
      dotCountBeforeAt = beforeAt.split('.').length - 1;

      String afterAt = filteredValue.substring(atIndex + 1);
      dotCountAfterAt = afterAt.split('.').length - 1;

      // Check if there is more than two dots after @ or if underscore or hyphen is present after @
      if (dotCountBeforeAt > 2 || dotCountAfterAt > 2 || underscoreCount > 0 || hyphenCount > 0) {
        return oldValue;
      }
    } else {
      dotCountBeforeAt = filteredValue.split('.').length - 1;

      if (dotCountBeforeAt > 2) {
        return oldValue;
      }
    }

    final int selectionStart = newValue.selection.start.clamp(0, filteredValue.length);
    final int selectionEnd = newValue.selection.end.clamp(0, filteredValue.length);

    return TextEditingValue(
      text: filteredValue,
      selection: TextSelection.collapsed(offset: selectionEnd),
    );
  }
}

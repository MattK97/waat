import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newappc/additional_widgets/hex_color.dart';
import 'package:newappc/globals/widgets/custom_attachment_picker.dart';
import 'package:newappc/globals/widgets/custom_creator_base.dart';
import 'package:newappc/globals/widgets/custom_input_field.dart';
import 'package:newappc/globals/widgets/custom_section_title.dart';
import 'package:newappc/models/ColorM.dart';
import 'package:newappc/models/announcement.dart';
import 'package:newappc/models/announcement_attachment.dart';
import 'package:newappc/screens/MainScreen.dart';
import 'package:newappc/views/news_tab/announcement_creator/viewmodel/announcement_creator_providers.dart';

import '../news_tab.dart';
import 'announcement_color_picker.dart';

class AnnouncementCreator extends StatefulWidget {
  final Announcement chosenAnnouncement;

  AnnouncementCreator({this.chosenAnnouncement});

  @override
  _AnnouncementCreatorState createState() => _AnnouncementCreatorState();
}

class _AnnouncementCreatorState extends State<AnnouncementCreator> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _infoController = TextEditingController();
  List<XFile> listOfAttachmentsFromDevice = [];
  List<AnnouncementAttachment> listOfAttachmentsFromWeb = [];
  ColorM _chosenColor;
  bool _isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.chosenAnnouncement == null ? '' : widget.chosenAnnouncement.name;
    _infoController.text = widget.chosenAnnouncement == null ? '' : widget.chosenAnnouncement.info;
    _chosenColor = widget.chosenAnnouncement == null
        ? null
        : ColorM(
            colorID: widget.chosenAnnouncement.colorID, colorHex: widget.chosenAnnouncement.color);
    listOfAttachmentsFromWeb =
        widget.chosenAnnouncement == null ? [] : widget.chosenAnnouncement.attachmentList;
    _updateButton('');
  }

  void _refreshColorPicker(ColorM chosenColor) {
    setState(() {
      _chosenColor = chosenColor;
    });
    _updateButton('');
  }

  void _updateButton(String value) {
    setState(() {
      _isButtonDisabled = _chosenColor == null || _titleController.text.isEmpty;
    });
  }

  void _addFileToListOfAnnouncementFromDevice(XFile file) {
    setState(() {
      listOfAttachmentsFromDevice.add(file);
    });
  }

  void _removeFileFromListOfAnnouncementFromDevice(XFile file) {
    setState(() {
      listOfAttachmentsFromDevice.remove(file);
    });
  }

  void _removeFileFromListOfAnnouncementFromWeb(AnnouncementAttachment announcementAttachment) {
    setState(() {
      listOfAttachmentsFromWeb.remove(announcementAttachment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (BuildContext context, WidgetRef ref, Widget child) {
        final announcementCreatorVM = ref.watch(announcementCreatorViewModel);
        final newsTabMainWidgetP = ref.watch(newsTabMainWidgetProvider.state);
        return CustomCreatorBase(
          isButtonDisabled: _isButtonDisabled,
          title: CustomSectionTitle(
            color: _chosenColor == null ? Colors.teal[400] : HexColor(_chosenColor.colorHex),
            leftIcon: CupertinoIcons.pin,
            disableRightIcon: false,
            rightIcon: CupertinoIcons.clear,
            title: AppLocalizations.of(context).announcement_creator,
            onPressed: () {
              newsTabMainWidgetP.state = NewsTab();
            },
          ),
          saveButtonColor:
              _chosenColor == null ? Colors.teal[400] : HexColor(_chosenColor.colorHex),
          children: [
            CustomInputField(
              fieldName: AppLocalizations.of(context).title,
              textEditingController: _titleController,
              notifyParent: _updateButton,
            ),
            CustomInputField(
              fieldName: AppLocalizations.of(context).info,
              textEditingController: _infoController,
              expanded: true,
            ),
            CustomAttachmentPicker(
              listOfAttachmentsFromDevice: listOfAttachmentsFromDevice,
              listOfAttachmentsFromWeb: listOfAttachmentsFromWeb,
              notifyParentOnNewFileFromDeviceAdded: _addFileToListOfAnnouncementFromDevice,
              notifyParentOnNewFileFromDeviceRemoved: _removeFileFromListOfAnnouncementFromDevice,
              notifyParentOnNewFileFromWebRemoved: _removeFileFromListOfAnnouncementFromWeb,
            ),
            AnnouncementColorPicker(
              colorM: _chosenColor,
              listOfColors: ref
                  .watch(colorListProvider.state)
                  .state
                  .where((element) => element.colorID <= 5)
                  .toList(),
              notifyParent: _refreshColorPicker,
            ),
          ],
          onSaveButtonPressed: () async {
            await announcementCreatorVM.operateOnAnnouncement(
                chosenAnnouncement: widget.chosenAnnouncement,
                title: _titleController.text,
                info: _infoController.text,
                color: _chosenColor,
                listOfAttachmentsFromDevice: listOfAttachmentsFromDevice,
                listOfAttachmentsFromWeb: listOfAttachmentsFromWeb);
          },
        );
      },
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newappc/globals/styles/paddings.dart';
import 'package:newappc/globals/styles/radiuses.dart';
import 'package:newappc/models/announcement_attachment.dart';

class CustomAttachmentPicker extends StatelessWidget {
  final List<XFile> listOfAttachmentsFromDevice;
  final List<AnnouncementAttachment> listOfAttachmentsFromWeb;
  final Function(XFile file) notifyParentOnNewFileFromDeviceAdded;
  final Function(XFile file) notifyParentOnNewFileFromDeviceRemoved;
  final Function(AnnouncementAttachment file) notifyParentOnNewFileFromWebRemoved;

  CustomAttachmentPicker(
      {Key key,
      this.listOfAttachmentsFromDevice,
      this.notifyParentOnNewFileFromDeviceAdded,
      this.notifyParentOnNewFileFromDeviceRemoved,
      this.listOfAttachmentsFromWeb,
      this.notifyParentOnNewFileFromWebRemoved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic> listOfAttachments = [...listOfAttachmentsFromDevice, ...listOfAttachmentsFromWeb];
    return Padding(
      padding: inputFieldPadding,
      child: InputDecorator(
        decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: borderRadius,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            labelText: 'Załącznik'),
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: listOfAttachments.length,
              itemBuilder: (context, index) {
                final item = listOfAttachments[index];
                return Container(
                  child: ListTile(
                    leading: Icon(CupertinoIcons.paperclip),
                    title: Text(item is XFile ? item.name : item.name,
                        style: TextStyle(color: Colors.grey)),
                    trailing: IconButton(
                      onPressed: () {
                        item is XFile
                            ? notifyParentOnNewFileFromDeviceRemoved(item)
                            : notifyParentOnNewFileFromWebRemoved(item);
                      },
                      icon: Icon(CupertinoIcons.trash),
                    ),
                  ),
                );
              },
            ),
            GestureDetector(
              onTap: () async {
                XFile pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                notifyParentOnNewFileFromDeviceAdded(pickedFile);
              },
              child: Container(
                child: ListTile(
                  leading: Icon(CupertinoIcons.add),
                  title: Text("Dodaj załącznik do tego ogłoszenia",
                      style: TextStyle(color: Colors.grey)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

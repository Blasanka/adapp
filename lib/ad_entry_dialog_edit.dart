import 'package:ad_app/model/ad.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

class AdEntryDialog extends StatefulWidget {
  final Ad adEntryToEdit;

  AdEntryDialog(this.adEntryToEdit);

  @override
  AdEntryDialogState createState() {
    String images = '';
    if (adEntryToEdit != null) {
      return new AdEntryDialogState(adEntryToEdit.price, adEntryToEdit.title,
          adEntryToEdit.description, images);
    } else {
      return new AdEntryDialogState(0.0, '', '', '');
    }
  }
}

class AdEntryDialogState extends State<AdEntryDialog> {
  double _price;
  String _title, _description, _imageUrl;
  TextEditingController _textController;

  AdEntryDialogState(
      this._price, this._title, this._description, this._imageUrl);

  Widget _createAppBar(BuildContext context) {
    return new AppBar(
      title: widget.adEntryToEdit == null
          ? const Text("New entry")
          : const Text("Edit entry"),
      actions: [
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop(new Ad(
                price: _price, title: _title, description: _description));
          },
          child: new Text('SAVE',
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _textController = new TextEditingController(text: _title);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: _createAppBar(context),
      body: new Column(
        children: [
          new ListTile(
            leading: new Icon(Icons.today, color: Colors.grey[500]),
            title: Text(_title),
          ),
          new ListTile(
            leading: new Image.network(
              _imageUrl,
              color: Colors.grey[500],
              height: 24.0,
              width: 24.0,
            ),
            title: new Text(
              "",
            ),
          ),
          new ListTile(
            leading: new Icon(Icons.speaker_notes, color: Colors.grey[500]),
            title: new TextField(
              decoration: new InputDecoration(
                hintText: 'Optional note',
              ),
              controller: _textController,
              onChanged: (value) => _title = value,
            ),
          ),
        ],
      ),
    );
  }
}

class DateTimeItem extends StatelessWidget {
  DateTimeItem({Key key, DateTime dateTime, @required this.onChanged})
      : assert(onChanged != null),
        date = dateTime == null
            ? new DateTime.now()
            : new DateTime(dateTime.year, dateTime.month, dateTime.day),
        time = dateTime == null
            ? new DateTime.now()
            : new TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
        super(key: key);

  final DateTime date;
  final TimeOfDay time;
  final ValueChanged<DateTime> onChanged;

  @override
  Widget build(BuildContext context) {
    return new Row(
      children: <Widget>[],
    );
  }
}

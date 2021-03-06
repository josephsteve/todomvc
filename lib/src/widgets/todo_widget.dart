// Copyright (c) 2017, Brian Armstrong. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of todomvc;

class TodoWidget extends StatefulWidget {
  final TodoItem todo;
  final bool disabled;
  final ValueChanged<bool> onToggle;
  final ValueChanged<String> onTitleChanged;
  final VoidCallback onDelete;

  TodoWidget({
    Key key,
    @required this.todo,
    this.disabled = false,
    this.onToggle,
    this.onTitleChanged,
    this.onDelete,
  })  : assert(todo != null),
        super(key: key);

  @override
  State<StatefulWidget> createState() => new _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  final TextEditingController _editTitleController = new TextEditingController();

  bool _editMode;

  @override
  void initState() {
    super.initState();
    _editMode = false;
  }

  Widget _buildEditTitle() {
    final String title = widget.todo.title;

    // Make sure the controller always has our current value
    _editTitleController.text = title;
    // Select all the text when we show the edit box
    _editTitleController.selection = new TextSelection(baseOffset: 0, extentOffset: title.length);

    return new TextField(
      autofocus: true,
      controller: _editTitleController,
      onSubmitted: (value) {
        setState(() {
          _editMode = false;
        });
        widget.onTitleChanged(value);
      },
    );
  }

  Widget _buildTitle(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    TextStyle titleStyle = theme.textTheme.body1;
    if (widget.disabled) {
      titleStyle = titleStyle.copyWith(color: Colors.grey);
    }

    return new GestureDetector(
      child: new Text(widget.todo.title, style: titleStyle),
      onLongPress: widget.disabled
          ? null
          : () {
              // Long press to edit
              if (widget.onTitleChanged != null) {
                setState(() {
                  _editMode = true;
                });
              }
            },
    );
  }

  @override
  Widget build(BuildContext context) {
    final Widget titleChild = (!widget.disabled && _editMode) ? _buildEditTitle() : _buildTitle(context);

    return new Row(
      children: <Widget>[
        new Checkbox(
          value: widget.todo.completed,
          onChanged: widget.disabled ? null : widget.onToggle,
        ),
        new Expanded(
          flex: 2,
          child: titleChild,
        ),
        new IconButton(
          icon: new Icon(Icons.delete),
          onPressed: widget.disabled ? null : widget.onDelete,
        ),
      ],
    );
  }
}

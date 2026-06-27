import 'package:flutter/material.dart';

class CheckBoxMenuEntry<T> {
  final T value;
  final String label;

  CheckBoxMenuEntry({required this.value, required this.label});
}

class MultiSelectCheckboxMenu<T> extends StatefulWidget {
  final List<CheckBoxMenuEntry<T>> checkboxMenuEntries;
  final void Function(Set<T> datas) onChanged;
  final Set<T>? initialSelection;
  final ButtonStyle? buttonStyle;
  final MenuStyle? menuStyle;
  final Widget child;

  const MultiSelectCheckboxMenu({
    super.key,
    required this.checkboxMenuEntries,
    required this.onChanged,
    this.initialSelection,
    this.buttonStyle,
    this.menuStyle,
    required this.child,
  });

  @override
  State<StatefulWidget> createState() => _MultiSelectCheckboxMenuState<T>();
}

class _MultiSelectCheckboxMenuState<T>
    extends State<MultiSelectCheckboxMenu<T>> {
  Set<T> _selectedEntries = {};

  @override
  void initState() {
    _selectedEntries = widget.initialSelection ?? {};

    super.initState();
  }

  void _toggleSelection(T value, bool isSelected) {
    setState(() {
      if (isSelected) {
        _selectedEntries.add(value);
      } else {
        _selectedEntries.remove(value);
      }
    });
    widget.onChanged(_selectedEntries);
  }

  @override
  Widget build(BuildContext context) {
    return MenuAnchor(
      menuChildren: widget.checkboxMenuEntries
          .map(
            (e) => CheckboxMenuButton(
              closeOnActivate: false,
              value: _selectedEntries.contains(e.value),
              onChanged: (value) {
                if (value != null) {
                  _toggleSelection(e.value, value);
                }
              },
              child: Text(e.label),
            ),
          )
          .toList(),

      style: widget.menuStyle,
      builder: (context, controller, child) {
        return ElevatedButton(
          onPressed: () {
            if (controller.isOpen) {
              controller.close();
            } else {
              controller.open();
            }
          },
          style: widget.buttonStyle,
          child: widget.child,
        );
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget buildTextFormField(
    TextEditingController controller, String label, IconData icon,
    {bool isOptional = false, TextInputType? keyboardType}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: isOptional ? label : '$label *',
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (!isOptional && (value == null || value.isEmpty)) {
          return 'Lütfen $label giriniz';
        }
        return null;
      },
      keyboardType: keyboardType,
    ),
  );
}

Widget buildDateFormField(
    TextEditingController controller, String label, IconData icon,
    {bool isDisabled = false, bool isOptional = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Builder(
      builder: (context) => TextFormField(
        controller: controller,
        readOnly: true,
        enabled: !isDisabled,
        decoration: InputDecoration(
          labelText: isOptional ? label : '$label *',
          prefixIcon: Icon(icon),
        ),
        onTap: !isDisabled
            ? () async {
                Locale myLocale = Localizations.localeOf(context);
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                  locale: myLocale,
                );
                if (pickedDate != null) {
                  controller.text = DateFormat('dd/MM/yyyy').format(pickedDate);
                }
              }
            : null,
        validator: (value) {
          if (!isOptional && !isDisabled && (value == null || value.isEmpty)) {
            return 'Lütfen $label giriniz';
          }
          return null;
        },
      ),
    ),
  );
}

Widget buildDropdown<T>(String label, T? selectedValue, List<T> items,
    ValueChanged<T?> onChanged, String Function(T) itemLabel, IconData icon,
    {bool isOptional = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: FormField<T>(
      builder: (FormFieldState<T> state) {
        return InputDecorator(
          decoration: InputDecoration(
            labelText: isOptional ? label : '$label *',
            prefixIcon: Icon(icon),
            errorText: state.hasError ? state.errorText : null,
          ),
          isEmpty: selectedValue == null,
          child: DropdownButtonHideUnderline(
            child: DropdownButton<T>(
              value: selectedValue,
              isExpanded: true,
              items: items.map((item) {
                return DropdownMenuItem<T>(
                  value: item,
                  child: Text(itemLabel(item)),
                );
              }).toList(),
              onChanged: (T? newValue) {
                state.didChange(newValue);
                onChanged(newValue);
              },
            ),
          ),
        );
      },
      validator: (value) {
        if (!isOptional && (value == null)) {
          return 'Lütfen $label seçiniz';
        }
        return null;
      },
      initialValue: selectedValue,
    ),
  );
}
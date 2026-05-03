import 'package:cielo_app/geocoding_api.dart';
import 'package:cielo_app/models/city_data.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CitySearchBar extends StatefulWidget {
  final GeocodingApi? api;
  final ValueChanged<CityData>? onCitySelected;

  const CitySearchBar({super.key, this.api, this.onCitySelected});

  @override
  State<CitySearchBar> createState() => CitySearchBarState();
}

class CitySearchBarState extends State<CitySearchBar> {
  static const searchDebounceDelay = Duration(milliseconds: 200);
  static const minimumSearchLength = 2;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500, maxHeight: 40),
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(12),
          clipBehavior: .antiAlias,
          child: Autocomplete<CityData>(
            displayStringForOption: (city) =>
                '${city.name}, ${city.admin1}, ${city.country}',
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: Material(
                  elevation: 4,
                  borderRadius: BorderRadius.circular(12),
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxWidth: 500,
                      maxHeight: 260,
                    ),
                    child: ListView.builder(
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: options.length,
                      itemBuilder: (context, index) {
                        final city = options.elementAt(index);

                        return ListTile(
                          leading: const Icon(
                            Icons.pin_drop,
                            color: Colors.blue,
                          ),
                          title: Text(
                            city.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('${city.admin1}, ${city.country}'),
                          onTap: () => onSelected(city),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
            onSelected: (city) {
              widget.onCitySelected?.call(city);
            },
            optionsBuilder: (TextEditingValue textEditingValue) async {
              final query = textEditingValue.text.trim();

              if (query.length < minimumSearchLength) {
                return const Iterable<CityData>.empty();
              }

              await Future<void>.delayed(searchDebounceDelay);

              try {
                return await (widget.api ?? GeocodingApi()).fetchCitiesData(
                  cityNameOrCode: query,
                );
              } catch (_) {
                return const Iterable<CityData>.empty();
              }
            },
            fieldViewBuilder:
                (context, textEditingController, focusNode, onFieldSubmitted) {
                  return TextField(
                    controller: textEditingController,
                    focusNode: focusNode,
                    onSubmitted: (_) => onFieldSubmitted(),
                    decoration: InputDecoration(
                      hintText: 'Rechercher une ville...',
                      prefixIcon: const Icon(Icons.search),
                      hintStyle: TextStyle(color: AppColors.forecastButtonText),
                      prefixIconColor: AppColors.forecastButtonText,
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(borderSide: BorderSide.none),
                    ),
                  );
                },
          ),
        ),
      ),
    );
  }
}

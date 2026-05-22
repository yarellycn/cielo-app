import 'package:cielo_app/geocoding_api.dart';
import 'package:cielo_app/models/city.dart';
import 'package:cielo_app/theme/app_button_styles.dart';
import 'package:cielo_app/theme/app_colors.dart';
import 'package:flutter/material.dart';

class CitySearchBar extends StatefulWidget {
  final GeocodingApi? api;
  final ValueChanged<City>? onCitySelected;

  const CitySearchBar({super.key, this.api, this.onCitySelected});

  @override
  State<CitySearchBar> createState() => CitySearchBarState();
}

class CitySearchBarState extends State<CitySearchBar> {
  static const searchDebounceDelay = Duration(milliseconds: 200);
  static const minimumSearchLength = 2;
  final double searchBarMaxWidth = 500;
  final double borderRadius = 12;
  bool isSearchFocused = false;
  TextEditingController? _textEditingController;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final seachFieldTextColor = AppColors.forecastButtonText;
    final searchFieldTextStyle = textTheme.bodySmall?.copyWith(
      color: seachFieldTextColor,
    );

    return Flexible(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: searchBarMaxWidth, maxHeight: 40),
        child: Focus(
          onFocusChange: (hasFocus) {
            setState(() {
              isSearchFocused = hasFocus;
            });
          },
          child: Material(
            elevation: isSearchFocused ? 0 : 1,
            borderRadius: BorderRadius.circular(borderRadius),
            clipBehavior: .antiAlias,
            child: Autocomplete<City>(
              displayStringForOption: (city) =>
                  '${city.name}, ${city.admin1}, ${city.country}',
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4,
                    borderRadius: BorderRadius.circular(borderRadius),
                    clipBehavior: .antiAlias,
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: searchBarMaxWidth,
                        maxHeight: 260,
                      ),
                      child: Builder(
                        builder: (context) {
                          final highlightedIndex =
                              AutocompleteHighlightedOption.of(context);

                          return ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: options.length,
                            itemBuilder: (context, index) {
                              final city = options.elementAt(index);
                              final isHighlighted = index == highlightedIndex;

                              return ListTile(
                                tileColor: isHighlighted
                                    ? AppColors.highlightedItemBackground
                                    : Colors.white,
                                leading: const Icon(
                                  Icons.pin_drop,
                                  color: Colors.blue,
                                ),
                                title: Text(
                                  city.name,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  '${city.admin1}, ${city.country}',
                                  style: textTheme.bodySmall?.copyWith(
                                    color: seachFieldTextColor,
                                  ),
                                ),
                                onTap: () => onSelected(city),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              onSelected: (city) {
                widget.onCitySelected?.call(city);
                _textEditingController?.clear();
              },
              optionsBuilder: (TextEditingValue textEditingValue) async {
                final query = textEditingValue.text.trim();

                if (query.length < minimumSearchLength) {
                  return const Iterable<City>.empty();
                }

                await Future<void>.delayed(searchDebounceDelay);

                try {
                  return await (widget.api ?? GeocodingApi()).fetchCitiesData(
                    cityNameOrCode: query,
                  );
                } catch (_) {
                  return const Iterable<City>.empty();
                }
              },
              fieldViewBuilder:
                  (
                    context,
                    textEditingController,
                    focusNode,
                    onFieldSubmitted,
                  ) {
                    _textEditingController = textEditingController;

                    return ValueListenableBuilder(
                      valueListenable: textEditingController,
                      builder: (context, value, child) {
                        return TextField(
                          controller: textEditingController,
                          focusNode: focusNode,
                          onSubmitted: (_) => onFieldSubmitted(),
                          style: searchFieldTextStyle,

                          decoration: InputDecoration(
                            hintText: 'Rechercher une ville...',
                            prefixIcon: const Icon(Icons.search, size: 18),
                            hintStyle: searchFieldTextStyle,
                            prefixIconColor: AppColors.forecastButtonText,
                            filled: true,
                            fillColor: Colors.white,
                            hoverColor: Colors.transparent,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                color: AppColors.highlightedItemBorder,
                              ),
                              borderRadius: BorderRadius.circular(borderRadius),
                            ),
                            suffixIcon: textEditingController.text.isEmpty
                                ? null
                                : Padding(
                                    padding: const EdgeInsets.only(right: 8.00),
                                    child: IconButton(
                                      tooltip: 'Effacer',
                                      icon: const Icon(Icons.close, size: 12),
                                      onPressed: () {
                                        textEditingController.clear();
                                      },
                                      style: AppButtonStyles.clearButton(),
                                    ),
                                  ),
                            suffixIconConstraints: const BoxConstraints(
                              minWidth: 30,
                              minHeight: 30,
                            ),
                          ),
                        );
                      },
                    );
                  },
            ),
          ),
        ),
      ),
    );
  }
}

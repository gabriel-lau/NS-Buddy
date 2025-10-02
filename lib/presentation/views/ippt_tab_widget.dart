import 'package:flutter/material.dart';
import 'package:ns_buddy/domain/interfaces/user_info_usecases.dart';
import 'package:ns_buddy/presentation/viewmodels/ippt_tab_viewmodel.dart';

import 'package:provider/provider.dart';

class IPPTTabWidget extends StatelessWidget {
  const IPPTTabWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        final ipptTabViewModel = IpptTabViewModel(
          userInfoUsecases: context.read<UserInfoUsecases>(),
        );
        ipptTabViewModel.resetParameters();
        ipptTabViewModel.loadIpptJson();
        return ipptTabViewModel;
      },
      child: _IPPTTabWidgetContent(),
    );
  }
}

class _IPPTTabWidgetContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ipptTabViewModel = context.watch<IpptTabViewModel>();
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        // Collapsible card at the top
                        Card(
                          child: ExpansionTile(
                            shape: Border.all(color: Colors.transparent),
                            title: Row(
                              children: [
                                Icon(
                                  Icons.edit,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Parameters',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                              ],
                            ),
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  16,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Age',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    const Spacer(),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.remove_circle_outline,
                                      ),
                                      tooltip: 'Decrease age',
                                      onPressed: () =>
                                          ipptTabViewModel.decreaseAge(),
                                    ),
                                    const SizedBox(width: 4),
                                    DropdownButton<int>(
                                      value: ipptTabViewModel.age,
                                      items: ipptTabViewModel.ageOptions
                                          .map(
                                            (a) => DropdownMenuItem<int>(
                                              value: a,
                                              child: Text('$a'),
                                            ),
                                          )
                                          .toList(),
                                      onChanged: (val) {
                                        if (val == null) return;
                                        ipptTabViewModel.setAge(val);
                                      },
                                    ),
                                    const SizedBox(width: 4),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.add_circle_outline,
                                      ),
                                      tooltip: 'Increase age',
                                      onPressed: () =>
                                          ipptTabViewModel.increaseAge(),
                                    ),
                                  ],
                                ),
                              ),
                              // Gender selector (disabled for now)
                              // Padding(
                              //   padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                              //   child: Row(
                              //     children: [
                              //       Text('Gender', style: Theme.of(context).textTheme.bodyLarge),
                              //       const Spacer(),
                              //       ToggleButtons(
                              //         isSelected: [
                              //           _genderLocal == 'male',
                              //           _genderLocal == 'female',
                              //         ],
                              //         onPressed: (index) {
                              //           setState(() {
                              //             _genderLocal = index == 0 ? 'male' : 'female';
                              //             _isEdited = true;
                              //           });
                              //         },
                              //         borderRadius: BorderRadius.circular(8),
                              //         children: const [
                              //           Padding(
                              //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              //             child: Text('Male'),
                              //           ),
                              //           Padding(
                              //             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              //             child: Text('Female'),
                              //           ),
                              //         ],
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // Shiong vocation switch (local only)
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Commando, NDU or Guards',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ),
                                    Switch(
                                      value: ipptTabViewModel.isShiongVocLocal,
                                      onChanged: (_) =>
                                          ipptTabViewModel.toggleIsShiongVoc(),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(
                                  16,
                                  0,
                                  16,
                                  12,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'NSF',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.bodyLarge,
                                      ),
                                    ),
                                    Switch(
                                      value: ipptTabViewModel.isNSF,
                                      onChanged: (_) =>
                                          ipptTabViewModel.toggleIsNSF(),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    if (ipptTabViewModel.isEdited)
                                      Chip(
                                        label: const Text('Edited'),
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        visualDensity: VisualDensity.compact,
                                        backgroundColor: Theme.of(
                                          context,
                                        ).colorScheme.tertiaryContainer,
                                        labelStyle: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.copyWith(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onTertiaryContainer,
                                            ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 0,
                                        ),
                                      ),
                                    const Spacer(),
                                    OutlinedButton.icon(
                                      onPressed:
                                          ipptTabViewModel.resetParameters,
                                      icon: const Icon(Icons.restart_alt),
                                      label: const Text('Reset'),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        // IPPT Score Calculator Card
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calculate,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'IPPT Score Calculator',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 24),
                                // Push-up Slider
                                Row(
                                  children: [
                                    Text(
                                      'Push-ups: ${ipptTabViewModel.pushUpValue.toInt()}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    Spacer(),
                                    Text(
                                      '${ipptTabViewModel.pushPoints} Points',
                                    ),
                                  ],
                                ),
                                Slider(
                                  value: ipptTabViewModel.pushUpValue,
                                  min: 0,
                                  max: 60,
                                  divisions: 60,
                                  onChanged: (value) =>
                                      ipptTabViewModel.pushUpValue = value,
                                ),
                                const SizedBox(height: 16),
                                // Sit-up Slider
                                Row(
                                  children: [
                                    Text(
                                      'Sit-ups: ${ipptTabViewModel.sitUpValue.toInt()} ',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    Spacer(),
                                    Text(
                                      '${ipptTabViewModel.sitPoints} Points',
                                    ),
                                  ],
                                ),
                                Slider(
                                  value: ipptTabViewModel.sitUpValue,
                                  min: 0,
                                  max: 60,
                                  divisions: 60,
                                  onChanged: (value) =>
                                      ipptTabViewModel.sitUpValue = value,
                                ),
                                const SizedBox(height: 16),
                                // 2.4km Run Slider
                                Row(
                                  children: [
                                    Text(
                                      '2.4km: ${(ipptTabViewModel.runValue / 60).toInt()} mins ${(ipptTabViewModel.runValue % 60).toInt()} sec',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyLarge,
                                    ),
                                    Spacer(),
                                    Text(
                                      '${ipptTabViewModel.runPoints} Points',
                                    ),
                                  ],
                                ),

                                Slider(
                                  value: ipptTabViewModel.runValue,
                                  min: 8 * 60,
                                  max: 20 * 60,
                                  divisions: 72,
                                  onChanged: (value) {
                                    ipptTabViewModel.runValue = value;
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              _buildScoreBar(context),
            ],
          );
        },
      ),
    );
  }

  Widget _buildScoreBar(BuildContext context) {
    final ipptTabViewModel = context.watch<IpptTabViewModel>();
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return SafeArea(
      top: false,
      child: Material(
        elevation: 6,
        color: scheme.surface,
        shadowColor: Colors.black26,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border(top: BorderSide(color: scheme.outlineVariant)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              Row(
                children: [
                  Text(
                    '${ipptTabViewModel.score} Points',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Spacer(),
                  _buildAwardChip(context),
                ],
              ),
              const SizedBox(height: 6),
              // Progress takes the most space
              Row(
                children: [
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            semanticsLabel: ipptTabViewModel.score.toString(),
                            value: ipptTabViewModel.score / 100.0,
                            minHeight: 8,
                            backgroundColor: scheme.surfaceContainerHighest,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              // Award chip
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAwardChip(BuildContext context) {
    final ipptTabViewModel = context.watch<IpptTabViewModel>();
    final ColorScheme scheme = Theme.of(context).colorScheme;
    Color background;
    Color foreground = scheme.onPrimary;

    switch (ipptTabViewModel.award) {
      case 'gold':
        background = Colors.amber.shade600;
        break;
      case 'silver':
        background = Colors.blueGrey.shade300;
        foreground = Colors.black87;
        break;
      case 'pass (incentive)':
        background = Colors.green.shade600;
        break;

      case 'pass':
        background = Colors.green.shade600;
        break;
      default:
        background = scheme.error;
        foreground = scheme.onError;
        break;
    }

    return Chip(
      label: Text(ipptTabViewModel.award.toUpperCase()),
      backgroundColor: background,
      labelStyle: Theme.of(
        context,
      ).textTheme.labelLarge?.copyWith(color: foreground),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
      visualDensity: VisualDensity.compact,
    );
  }
}

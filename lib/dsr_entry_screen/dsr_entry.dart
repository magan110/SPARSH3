import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

import 'Meeting_with_new_purchaser.dart';
import 'Meetings_With_Contractor.dart';
import 'any_other_activity.dart';
import 'btl_activites.dart';
import 'check_sampling_at_site.dart';
import 'dsr_retailer_in_out.dart';
import 'internal_team_meeting.dart';
import 'office_work.dart';
import 'on_leave.dart';
import 'phone_call_with_builder.dart';
import 'phone_call_with_unregisterd_purchaser.dart';
import 'work_from_home.dart';
import 'package:learning2/screens/Home_screen.dart';
import 'package:learning2/theme/app_theme.dart';

class DsrEntry extends StatefulWidget {
  const DsrEntry({super.key});

  @override
  State<DsrEntry> createState() => _DsrEntryState();
}

class _DsrEntryState extends State<DsrEntry> {
  final List<String> _activityItems = [
    'Personal Visit',
    'Phone Call with Builder/Stockist',
    'Meetings With Contractor / Stockist',
    'Visit to Get / Check Sampling at Site',
    'Meeting with New Purchaser(Trade Purchaser)/Retailer',
    'BTL Activities',
    'Internal Team Meetings / Review Meetings',
    'Office Work',
    'On Leave / Holiday / Off Day',
    'Work From Home',
    'Any Other Activity',
    'Phone call with Unregistered Purchasers',
  ];
  String? _selectedActivity;

  final Map<String, IconData> _activityIcons = {
    'Personal Visit': Icons.person_pin_circle,
    'Phone Call with Builder/Stockist': Icons.phone_in_talk,
    'Meetings With Contractor / Stockist': Icons.groups,
    'Visit to Get / Check Sampling at Site': Icons.fact_check,
    'Meeting with New Purchaser(Trade Purchaser)/Retailer': Icons.handshake,
    'BTL Activities': Icons.campaign,
    'Internal Team Meetings / Review Meetings': Icons.people_outline,
    'Office Work': Icons.desktop_windows,
    'On Leave / Holiday / Off Day': Icons.beach_access,
    'Work From Home': Icons.home_work,
    'Any Other Activity': Icons.miscellaneous_services,
    'Phone call with Unregistered Purchasers': Icons.call,
  };

  final _formKey = GlobalKey<FormState>();

  void _navigateTo(String label) {
    final map = {
      'Personal Visit': () => DsrRetailerInOut(),
      'Phone Call with Builder/Stockist': () => PhoneCallWithBuilder(),
      'Meetings With Contractor / Stockist': () => MeetingsWithContractor(),
      'Visit to Get / Check Sampling at Site': () => CheckSamplingAtSite(),
      'Meeting with New Purchaser(Trade Purchaser)/Retailer':
          () => MeetingWithNewPurchaser(),
      'BTL Activities': () => BtlActivities(),
      'Internal Team Meetings / Review Meetings': () => InternalTeamMeeting(),
      'Office Work': () => OfficeWork(),
      'On Leave / Holiday / Off Day': () => OnLeave(),
      'Work From Home': () => WorkFromHome(),
      'Any Other Activity': () => AnyOtherActivity(),
      'Phone call with Unregistered Purchasers':
          () => PhoneCallWithUnregisterdPurchaser(),
    };
    final builder = map[label];
    if (builder != null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => builder()));
    }
  }

  Widget _buildActivityGrid(double maxWidth) {
    // Determine cols: phones=2, small tablets=3, large=4
    int crossAxisCount = 2;
    if (maxWidth >= 900) {
      crossAxisCount = 4;
    } else if (maxWidth >= 600) {
      crossAxisCount = 3;
    }

    // Responsive spacing and sizing
    final spacing = maxWidth * 0.04;
    final iconSize = (maxWidth * 0.08).clamp(24.0, 36.0);
    final fontSize = (maxWidth * 0.032).clamp(11.0, 15.0);
    final padding = maxWidth * 0.03;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 1.18,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
      ),
      itemCount: _activityItems.length,
      itemBuilder: (context, i) {
        final label = _activityItems[i];
        final selected = _selectedActivity == label;
        return GestureDetector(
          onTap: () {
            setState(() => _selectedActivity = label);
            _navigateTo(label);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(
                color: selected ? AppTheme.primaryColor : Colors.grey.shade200,
                width: selected ? 2 : 1,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(padding),
                  child: Icon(
                    _activityIcons[label] ?? Icons.assignment,
                    size: iconSize,
                    color: AppTheme.primaryColor,
                  ),
                ),
                SizedBox(height: maxWidth * 0.02),
                Flexible(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed:
                () => Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => const HomeScreen())),
          ),
          title: Row(
            children: [
              Icon(
                Icons.assignment_outlined,
                size: (MediaQuery.of(context).size.width * 0.07).clamp(
                  24.0,
                  32.0,
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width * 0.025),
              Text(
                'DSR Entry',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: (MediaQuery.of(context).size.width * 0.05).clamp(
                    18.0,
                    24.0,
                  ),
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          backgroundColor: AppTheme.primaryColor,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15),
            ),
          ),
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final responsivePadding = screenWidth * 0.04;

            return SingleChildScrollView(
              padding: EdgeInsets.all(responsivePadding),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Instructions
                    Container(
                      padding: EdgeInsets.all(responsivePadding),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withValues(alpha: 0.3),
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            spacing: 8,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: (MediaQuery.of(context).size.width * 0.06)
                                    .clamp(20.0, 28.0),
                              ),
                              Text(
                                'Instructions',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: (MediaQuery.of(context).size.width *
                                          0.05)
                                      .clamp(18.0, 22.0),
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Fill in the details below to submit your daily sales report.',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: (MediaQuery.of(context).size.width *
                                      0.035)
                                  .clamp(12.0, 16.0),
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Activity Information
                    AppTheme.buildSectionCard(
                      title: 'Activity Information',
                      icon: Icons.category_outlined,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 4, bottom: 6),
                          child: Text(
                            'Activity Type',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                        _buildActivityGrid(constraints.maxWidth),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

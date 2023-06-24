import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ToDoListTheme {
  static final _islLghtBrightness =
      SchedulerBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.light;

  static Color get textColor =>
      _islLghtBrightness ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  static Color get completedTextColor =>
      _islLghtBrightness ? const Color(0xFFD1D1D6) : const Color(0xFF8E8E93);

  static Color get mainScreenScaffoldColor =>
      _islLghtBrightness ? const Color(0xFFF7F6F2) : const Color(0xFF161618);
  static Color get mainScreenAppBarColor =>
      _islLghtBrightness ? const Color(0xFFF7F6F2) : const Color(0xFF161618);
  static Color get mainScreenListColor =>
      _islLghtBrightness ? const Color(0xFFFFFFFF) : const Color(0xFF252528);
  static Color get mainScreenCompletedColor =>
      _islLghtBrightness ? const Color(0xFFD1D1D6) : const Color(0xFF48484A);
  static Color get mainScreenEyeColor =>
      _islLghtBrightness ? const Color(0xFF007AFF) : const Color(0xFF0A84FF);
  static Color get mainScreenTaskListColor =>
      _islLghtBrightness ? const Color(0xFFFFFFFF) : const Color(0xFF252528);
  static Color get mainScreenNewColor =>
      _islLghtBrightness ? const Color(0xFFD1D1D6) : const Color(0xFF8E8E93);

  static Color get floatingActionButtonIconColor =>
      _islLghtBrightness ? const Color(0xFFFFFFFF) : const Color(0xFFFFFFFF);
  static Color get floatingActionButtonBackgroundColor =>
      _islLghtBrightness ? const Color(0xFF007AFF) : const Color(0xFF0A84FF);

  static Color get taskRowCheckBoxSimpleColor =>
      _islLghtBrightness ? const Color(0xFFD1D1D6) : const Color(0xFF48484A);
  static Color get taskRowCheckBoxHighRelevanceColor =>
      _islLghtBrightness ? const Color(0xFFFF3B30) : const Color(0xFFFF453A);
  static Color get taskRowLowRelevanceColor =>
      _islLghtBrightness ? const Color(0xFF8E8E93) : const Color(0xFF8E8E93);
  static Color get taskRowCheckBoxCompletedColor =>
      _islLghtBrightness ? const Color(0xFF34C759) : const Color(0xFF32D74B);
  static Color get taskRowCheckBoxInfoButtonColor =>
      _islLghtBrightness ? const Color(0x33000000) : const Color(0xFF8E8E93);
  static Color get taskRowDateColor =>
      _islLghtBrightness ? const Color(0xFFD1D1D6) : const Color(0xFF8E8E93);

  static Color get taskFormScaffoldColor =>
      _islLghtBrightness ? const Color(0xFFF7F6F2) : const Color(0xFF161618);
  static Color get taskFormAppBarColor =>
      _islLghtBrightness ? const Color(0xFFF7F6F2) : const Color(0xFF161618);
  static Color get taskFormAppBarIconColor =>
      _islLghtBrightness ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  static Color get taskFormAppBarSaveColor =>
      _islLghtBrightness ? const Color(0xFF007AFF) : const Color(0xFF0A84FF);
  static Color get taskFormTextFieldColor =>
      _islLghtBrightness ? const Color(0xFFFFFFFF) : const Color(0xFF252528);
  static Color get taskFormTextColor =>
      _islLghtBrightness ? const Color(0xFF000000) : const Color(0xFFFFFFFF);
  static Color get taskFormHintTextColor =>
      _islLghtBrightness ? const Color(0x33000000) : const Color(0xFF8E8E93);
  static Color get taskFormNoneRelevanceColor =>
      _islLghtBrightness ? const Color(0x33000000) : const Color(0xFF48484A);
  static Color get taskFormLowRelevanceColor =>
      _islLghtBrightness ? const Color(0xFF007AFF) : const Color(0xFF0A84FF);
  static Color get taskFormActiveSwitchColor =>
      _islLghtBrightness ? const Color(0xFF007AFF) : const Color(0xFF0A84FF);
  static Color get taskFormTrackSwitchColor =>
      _islLghtBrightness ? const Color(0x0F000000) : const Color(0xFF000000);
  static Color get taskFormTrackActiveSwitchColor => _islLghtBrightness
      ? const Color.fromARGB(88, 0, 123, 255)
      : const Color.fromARGB(88, 0, 123, 255);
  static Color get taskFormInactiveThumbSwitchColor =>
      _islLghtBrightness ? const Color(0xFFFFFFFF) : const Color(0xFF48484A);
  static Color get taskFormDisableDeleteColor =>
      _islLghtBrightness ? const Color(0x33000000) : const Color(0xFF252528);
  static Color get taskFormDeleteColor =>
      _islLghtBrightness ? const Color(0xFFFF3B30) : const Color(0xFFFF453A);
  static Color get taskFormDateColor =>
      _islLghtBrightness ? const Color(0xFF007AFF) : const Color(0xFF0A84FF);
  static Color get taskFormPopupMenuColor =>
      _islLghtBrightness ? const Color(0xFFFFFFFF) : const Color(0xFF48484A);
  static Color get taskFormDatePickerButtonsColor =>
      _islLghtBrightness ? const Color(0xFF007AFF) : const Color(0xFF0A84FF);
  static Color get taskFormDatePickerPrimaryColor =>
      _islLghtBrightness ? const Color(0xFF007AFF) : const Color(0xFF0A84FF);
  static Color get taskFormDatePickerDialogBackgroundColor =>
      _islLghtBrightness ? const Color(0xFFFFFFFF) : const Color(0xFF252528);
}

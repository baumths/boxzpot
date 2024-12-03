import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('pt')
  ];

  /// No description provided for @addBoxButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Box'**
  String get addBoxButtonLabel;

  /// No description provided for @addDocumentButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Add Document'**
  String get addDocumentButtonLabel;

  /// No description provided for @boxCodeFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get boxCodeFormFieldLabel;

  /// No description provided for @boxDescriptionFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get boxDescriptionFormFieldLabel;

  /// No description provided for @boxDocumentsOverviewEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'This box appears to be empty.\nLet\'s add a Document to it?'**
  String get boxDocumentsOverviewEmptyMessage;

  /// No description provided for @boxesOverviewEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t find any boxes around.\nLet\'s add a new one?'**
  String get boxesOverviewEmptyMessage;

  /// No description provided for @boxNameFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get boxNameFormFieldLabel;

  /// No description provided for @cancelButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonLabel;

  /// No description provided for @closeBoxButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Close Box'**
  String get closeBoxButtonLabel;

  /// No description provided for @deleteConfirmationDialogContent.
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone.'**
  String get deleteConfirmationDialogContent;

  /// No description provided for @deleteConfirmationDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Are you sure?'**
  String get deleteConfirmationDialogTitle;

  /// No description provided for @documentAccessPointsFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Access Points'**
  String get documentAccessPointsFormFieldLabel;

  /// No description provided for @documentCodeFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Code'**
  String get documentCodeFormFieldLabel;

  /// No description provided for @documentDateFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get documentDateFormFieldLabel;

  /// No description provided for @documentTitleFormFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get documentTitleFormFieldLabel;

  /// No description provided for @editBoxButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Edit Box'**
  String get editBoxButtonLabel;

  /// No description provided for @editBoxFormHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing Box'**
  String get editBoxFormHeaderTitle;

  /// No description provided for @editDocumentFormHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'Editing Document'**
  String get editDocumentFormHeaderTitle;

  /// No description provided for @emptyFormFieldValidationMessage.
  ///
  /// In en, this message translates to:
  /// **'{fieldLabel} must not be empty.'**
  String emptyFormFieldValidationMessage({required String fieldLabel});

  /// No description provided for @newBoxFormHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'New Box'**
  String get newBoxFormHeaderTitle;

  /// No description provided for @newDocumentButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'New Document'**
  String get newDocumentButtonLabel;

  /// No description provided for @newDocumentFormHeaderTitle.
  ///
  /// In en, this message translates to:
  /// **'New Document'**
  String get newDocumentFormHeaderTitle;

  /// No description provided for @saveButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveButtonLabel;

  /// No description provided for @viewBoxQrCodeButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'View QR Code'**
  String get viewBoxQrCodeButtonLabel;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'pt': return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}

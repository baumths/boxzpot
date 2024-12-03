import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get addBoxButtonLabel => 'Add Box';

  @override
  String get addDocumentButtonLabel => 'Add Document';

  @override
  String get boxCodeFormFieldLabel => 'Code';

  @override
  String get boxDescriptionFormFieldLabel => 'Description';

  @override
  String get boxDocumentsOverviewEmptyMessage => 'This box appears to be empty.\nLet\'s add a Document to it?';

  @override
  String get boxesOverviewEmptyMessage => 'Couldn\'t find any boxes around.\nLet\'s add a new one?';

  @override
  String get boxNameFormFieldLabel => 'Name';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get closeBoxButtonLabel => 'Close Box';

  @override
  String get deleteConfirmationDialogContent => 'This action cannot be undone.';

  @override
  String get deleteConfirmationDialogTitle => 'Are you sure?';

  @override
  String get documentAccessPointsFormFieldLabel => 'Access Points';

  @override
  String get documentCodeFormFieldLabel => 'Code';

  @override
  String get documentDateFormFieldLabel => 'Date';

  @override
  String get documentTitleFormFieldLabel => 'Title';

  @override
  String get editBoxButtonLabel => 'Edit Box';

  @override
  String get editBoxFormHeaderTitle => 'Editing Box';

  @override
  String get editDocumentFormHeaderTitle => 'Editing Document';

  @override
  String emptyFormFieldValidationMessage({required String fieldLabel}) {
    return '$fieldLabel must not be empty.';
  }

  @override
  String get newBoxFormHeaderTitle => 'New Box';

  @override
  String get newDocumentButtonLabel => 'New Document';

  @override
  String get newDocumentFormHeaderTitle => 'New Document';

  @override
  String get saveButtonLabel => 'Save';

  @override
  String get viewBoxQrCodeButtonLabel => 'View QR Code';
}

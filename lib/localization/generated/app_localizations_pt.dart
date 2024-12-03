import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get addBoxButtonLabel => 'Adicionar Caixa';

  @override
  String get addDocumentButtonLabel => 'Adicionar Documento';

  @override
  String get boxCodeFormFieldLabel => 'Código';

  @override
  String get boxDescriptionFormFieldLabel => 'Descrição';

  @override
  String get boxDocumentsOverviewEmptyMessage => 'Esta caixa está aparentemente vazia.\nVamos adicionar um documento a ela?';

  @override
  String get boxesOverviewEmptyMessage => 'Não foi possível encontrar nenhuma caixa.\nVamos adicionar uma nova?';

  @override
  String get boxNameFormFieldLabel => 'Nome';

  @override
  String get cancelButtonLabel => 'Cancelar';

  @override
  String get closeBoxButtonLabel => 'Fechar Caixa';

  @override
  String get deleteConfirmationDialogContent => 'Esta ação não pode ser desfeita.';

  @override
  String get deleteConfirmationDialogTitle => 'Tem certeza?';

  @override
  String get documentAccessPointsFormFieldLabel => 'Pontos de Acesso';

  @override
  String get documentCodeFormFieldLabel => 'Código';

  @override
  String get documentDateFormFieldLabel => 'Data';

  @override
  String get documentTitleFormFieldLabel => 'Título';

  @override
  String get editBoxButtonLabel => 'Editar Caixa';

  @override
  String get editBoxFormHeaderTitle => 'Editando Caixa';

  @override
  String get editDocumentFormHeaderTitle => 'Editando Documento';

  @override
  String emptyFormFieldValidationMessage({required String fieldLabel}) {
    return '$fieldLabel não pode estar em branco.';
  }

  @override
  String get newBoxFormHeaderTitle => 'Nova Caixa';

  @override
  String get newDocumentButtonLabel => 'Novo Documento';

  @override
  String get newDocumentFormHeaderTitle => 'Novo Documento';

  @override
  String get saveButtonLabel => 'Salvar';

  @override
  String get viewBoxQrCodeButtonLabel => 'Visualizar QR Code';
}

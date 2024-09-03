class SignUpWithEmailAndPasswordFailure {
  final String message;

  const SignUpWithEmailAndPasswordFailure([this.message = "Campi errati o mancanti."]);

  factory SignUpWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return SignUpWithEmailAndPasswordFailure('Per favore inserisci una password più sicura');
      case 'invalid-email':
        return SignUpWithEmailAndPasswordFailure('Email inserita non valida');
      case 'email-already-in-use':
        return SignUpWithEmailAndPasswordFailure('Esiste già un account per questa email');
      case 'operation-not-allowed':
        return SignUpWithEmailAndPasswordFailure('Operazione non valida');
      case 'user-disabled':
        return SignUpWithEmailAndPasswordFailure('Questo utente è stato disabilitato');
      default:
        return const SignUpWithEmailAndPasswordFailure();
    }
  }
}

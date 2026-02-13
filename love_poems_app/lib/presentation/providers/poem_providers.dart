import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/poem.dart';
import '../../data/repositories/supabase_poem_repository.dart';

// Repository provider
final poemRepositoryProvider = Provider<SupabasePoemRepository>((ref) {
  return SupabasePoemRepository();
});

// Daily letter state
enum DailyLetterState { loading, sealed, opened, waitUntilTomorrow, error }

class DailyLetterData {
  final DailyLetterState state;
  final Poem? currentPoem;
  final String? errorMessage;

  const DailyLetterData({
    required this.state,
    this.currentPoem,
    this.errorMessage,
  });

  DailyLetterData copyWith({
    DailyLetterState? state,
    Poem? currentPoem,
    String? errorMessage,
  }) {
    return DailyLetterData(
      state: state ?? this.state,
      currentPoem: currentPoem ?? this.currentPoem,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class DailyLetterNotifier extends StateNotifier<DailyLetterData> {
  final SupabasePoemRepository _repository;

  DailyLetterNotifier(this._repository)
      : super(const DailyLetterData(state: DailyLetterState.loading)) {
    _checkLetterState();
  }

  Future<void> _checkLetterState() async {
    try {
      final canOpen = await _repository.canOpenNewLetter();
      if (canOpen) {
        state = const DailyLetterData(state: DailyLetterState.sealed);
      } else {
        state = const DailyLetterData(state: DailyLetterState.waitUntilTomorrow);
      }
    } catch (e) {
      state = DailyLetterData(
        state: DailyLetterState.error,
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> openEnvelope() async {
    if (state.state != DailyLetterState.sealed) return;

    state = const DailyLetterData(state: DailyLetterState.loading);

    try {
      final poem = await _repository.getDailyLetter();
      await _repository.unlockPoem(poem.id);
      await _repository.setLastOpenedDate(DateTime.now());

      state = DailyLetterData(
        state: DailyLetterState.opened,
        currentPoem: poem,
      );
    } catch (e) {
      state = DailyLetterData(
        state: DailyLetterState.error,
        errorMessage: e.toString(),
      );
    }
  }

  void reset() {
    _checkLetterState();
  }
}

final dailyLetterProvider =
    StateNotifierProvider<DailyLetterNotifier, DailyLetterData>((ref) {
  final repository = ref.read(poemRepositoryProvider);
  return DailyLetterNotifier(repository);
});

// Archive provider
final archiveProvider = FutureProvider<List<Poem>>((ref) async {
  final repository = ref.read(poemRepositoryProvider);
  return repository.getUnlockedPoems();
});

// All poems provider
final allPoemsProvider = FutureProvider<List<Poem>>((ref) async {
  final repository = ref.read(poemRepositoryProvider);
  return repository.getAllPublicPoems();
});

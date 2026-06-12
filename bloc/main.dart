import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CharacterState {
  final int level;
  final int exp;
  final int power;
  final String message;

  CharacterState({
    required this.level,
    required this.exp,
    required this.power,
    required this.message,
  });

  CharacterState copyWith({int? level, int? exp, int? power, String? message}) {
    return CharacterState(
      level: level ?? this.level,
      exp: exp ?? this.exp,
      power: power ?? this.power,
      message: message ?? this.message,
    );
  }
}

abstract class CharacterEvent {}

class GainExp extends CharacterEvent {
  final int expGained;
  GainExp(this.expGained);
}

class GainPower extends CharacterEvent {}

class CharacterBloc extends Bloc<CharacterEvent, CharacterState> {
  CharacterBloc()
    : super(
        CharacterState(
          level: 1,
          exp: 0,
          power: 10,
          message: "Character Berhasil Dibuat",
        ),
      ) {
    on<GainExp>((event, emit) {
      int tempExp = state.exp + event.expGained;
      if (tempExp >= 100) {
        emit(
          state.copyWith(
            level: state.level + 1,
            exp: tempExp - 100,
            power: state.power + 5,
            message: "Level Up! Level: ${state.level + 1}",
          ),
        );
      } else {
        emit(
          state.copyWith(
            exp: tempExp,
            message: "Gained ${event.expGained} EXP",
          ),
        );
      }
    });
    on<GainPower>((event, emit) {
      emit(state.copyWith(power: state.power + 7, message: "Gained 7 Power"));
    });
  }
}

void main() {
  runApp(
    BlocProvider(
      create: (context) => CharacterBloc(),
      child: const MaterialApp(home: CharacterScreen()),
    ),
  );
}

class CharacterScreen extends StatelessWidget {
  const CharacterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Character State Management")),
      body: BlocBuilder<CharacterBloc, CharacterState>(
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Level: ${state.level}",
                  style: const TextStyle(fontSize: 24),
                ),
                Text("EXP: ${state.exp}", style: const TextStyle(fontSize: 24)),
                Text(
                  "Power: ${state.power}",
                  style: const TextStyle(fontSize: 24),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => context.read<CharacterBloc>().add(
                    GainExp(Random().nextInt(50) + 10),
                  ),
                  child: const Text("Gain EXP"),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () =>
                      context.read<CharacterBloc>().add(GainPower()),
                  child: const Text("Gain Power"),
                ),
                const SizedBox(height: 20),
                Text(
                  state.message,
                  style: const TextStyle(fontSize: 18, color: Colors.blue),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

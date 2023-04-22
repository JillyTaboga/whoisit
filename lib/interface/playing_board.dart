import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/databases/humans1/humans1_db.dart';
import '../domain/entities/it_entity.dart';

final misteryProvider = Provider<ItEntity>((ref) {
  return humans1[Random().nextInt(humans1.length)];
});

class PlayingGameBoard extends ConsumerWidget {
  const PlayingGameBoard({super.key});

  final xCount = 4;
  final yCount = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        title: const Text('Cara a Cara'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              ref.invalidate(misteryProvider);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final possibleHeight = constraints.maxHeight / yCount;
                final basicHeight =
                    constraints.maxWidth / xCount * yCount / xCount;
                final height =
                    basicHeight > possibleHeight ? possibleHeight : basicHeight;
                final widht = height * xCount / yCount;
                return SizedBox(
                  width: widht * xCount,
                  child: Center(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: xCount,
                        childAspectRatio: xCount / yCount,
                      ),
                      itemCount: humans1.length,
                      itemBuilder: (_, index) {
                        return ItWidget(it: humans1[index]);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(10),
            child: MisteryWidget(),
          ),
        ],
      ),
    );
  }
}

class MisteryWidget extends ConsumerWidget {
  const MisteryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context, ref) {
    final it = ref.watch(misteryProvider);
    return SizedBox(
      height: 120,
      child: Center(
        child: AspectRatio(
          aspectRatio: 4 / 5,
          child: InkWell(
            onTap: () {
              showDialog(context: context, builder: (_) => ItDialog(it: it));
            },
            child: Container(
              width: double.maxFinite,
              height: double.maxFinite,
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(5),
              ),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    it.asset,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 5,
                    left: 0,
                    right: 0,
                    child: Text(
                      it.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 2,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItWidget extends StatefulWidget {
  const ItWidget({
    super.key,
    required this.it,
  });

  final ItEntity it;

  @override
  State<ItWidget> createState() => _ItWidgetState();
}

class _ItWidgetState extends State<ItWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late ItEntity it;
  bool opened = true;
  double offset = 0;

  @override
  void initState() {
    super.initState();
    it = widget.it;
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  void didUpdateWidget(covariant ItWidget oldWidget) {
    if (it != widget.it) {
      setState(() {
        it = widget.it;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  change() {
    if (opened) {
      animationController.forward().whenComplete(() => opened = false);
    } else {
      animationController.reverse().whenComplete(() => opened = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.grey.shade600,
        border: Border.all(color: Colors.black, width: 0.1),
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.black54,
        ),
        child: AnimatedBuilder(
          animation: animationController,
          builder: (context, child) {
            final rotateX =
                ((animationController.value * 10.5 * (opened ? 1 : -1)) +
                        offset)
                    .clamp(1, 150)
                    .toDouble();
            offset = rotateX;
            return Transform(
              alignment: FractionalOffset.bottomCenter,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.0005)
                ..rotateX(0.01 * rotateX),
              child: Consumer(
                builder: (context, ref, child) {
                  return GestureDetector(
                    onTap: change,
                    onLongPress: () {
                      showDialog(
                        context: context,
                        builder: (_) {
                          return ItDialog(it: it);
                        },
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        border: Border.all(
                          color: Colors.black,
                          width: 0.5,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(5),
                        ),
                      ),
                      padding: const EdgeInsets.only(
                        bottom: 3,
                        top: 6,
                        left: 3,
                        right: 3,
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            it.asset,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            bottom: 5,
                            left: 0,
                            right: 0,
                            child: Text(
                              it.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2,
                                shadows: [
                                  Shadow(
                                    color: Colors.black54,
                                    blurRadius: 2,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class ItDialog extends StatelessWidget {
  const ItDialog({
    super.key,
    required this.it,
  });

  final ItEntity it;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        side: const BorderSide(
          color: Colors.grey,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Image.asset(it.asset),
          Positioned(
            bottom: 10,
            left: 0,
            right: 0,
            child: Text(
              it.name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                fontSize: 30,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    blurRadius: 2,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

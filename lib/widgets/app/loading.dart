import 'package:flutter/material.dart';
import 'package:tusalud/style/app_style.dart';

class Loading extends StatelessWidget {
  const Loading({super.key, this.message, this.title});

  final String? title;
  final String? message;

  @override
  Widget build(BuildContext context) {
    double width = 300;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: width,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: SizedBox(
                    width: 50,
                    height: 50,
                    child: CircularProgressIndicator(
                      color: AppStyle.primary,
                    ),
                  ),
                ),
                if (title != null)
                  Container(
                    height: message != null ? 80 : 100,
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Center(
                      child: Text(title ?? "",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          decoration: TextDecoration.none,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppStyle.black
                        )
                      ),
                    ),
                  ),
                if (message != null)
                  Container(
                    height: title != null ? 50 : 100,
                    padding: const EdgeInsets.only(bottom: 20.0, top: 5.0),
                    child: Center(
                      child: Text(message ?? "",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          decoration: TextDecoration.none,
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                          color: AppStyle.black
                        )
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
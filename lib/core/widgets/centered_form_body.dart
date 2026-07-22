import 'package:flutter/material.dart';

/// Standard body for the auth forms: taps outside a field dismiss the
/// keyboard, content is vertically centered when it fits the viewport,
/// and scrolls normally once it doesn't (e.g. with the keyboard open).
class CenteredFormBody extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  const CenteredFormBody({
    super.key,
    required this.formKey,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24),
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: children,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

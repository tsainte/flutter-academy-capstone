import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_academy_capstone/components/cheap_checkbox.dart';
import 'package:flutter_academy_capstone/components/nav_bar.dart';
import 'package:flutter_academy_capstone/components/progress.dart';
import 'package:flutter_academy_capstone/model/study_aid.dart';
import 'package:flutter_academy_capstone/model/study_aid_notifier.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyAidView extends ConsumerWidget {
  StudyAidView(this._studyAidId, this._studyAidTitle, {Key? key})
      : super(key: key);
  final int _studyAidId;
  final String _studyAidTitle;

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final studyAidNotifier = watch(studyAidProvider.notifier);

    return CupertinoPageScaffold(
      child: SafeArea(
        child: Container(
          color: Colors.white,
          child: FutureBuilder(
            future: studyAidNotifier.fetchStudyAidDetails(_studyAidId),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  print('active');
                  break;
                case ConnectionState.done:
                  return _ContentStudyAid(studyAidNotifier.content);
                case ConnectionState.none:
                  print('none');
                  break;
                case ConnectionState.waiting:
                  return Progress();
              }
              return Container(
                child: Text('unkwown error'),
                color: Colors.white,
              );
            },
          ),
        ),
      ),
      navigationBar: NavBar.make(_studyAidTitle),
    );
  }
}

class _ContentStudyAid extends StatelessWidget {
  final String _content;
  _ContentStudyAid(
    this._content, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0.0),
            child: ListView(
              children: [
                _markdownWidget(_content),
                _Checklist(),
              ],
            ),
          ),
        ),
        CompleteBanner(),
      ],
    );
  }

  Widget _markdownWidget(String content) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: MarkdownBody(
            onTapLink: (text, url, title) {
              if (url != null) {
                openURL(url);
              }
            },
            data: content));
  }

  void openURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
}

class _Checklist extends ConsumerWidget {
  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final _ = watch(studyAidProvider);
    StudyAidNotifier notifier = watch(studyAidProvider.notifier);
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          _headerChecklist(notifier.checklistText()),
          SizedBox(height: 16.0),
          for (int i = 0; i < notifier.checklistCount; i++)
            _checklistItem(i, notifier),
        ]),
      ),
    );
  }

  Widget _headerChecklist(String text) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Checklist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(text),
      ],
    );
  }

  Widget _checklistItem(int index, StudyAidNotifier notifier) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CheapCheckbox(
            notifier.itemIsChecked(index),
            onChanged: (bool value) {
              notifier.setIsChecked(index, value);
            },
          ),
          SizedBox(width: 8),
          Expanded(child: Text(notifier.itemTitle(index))),
        ],
      ),
    );
  }
}

class CompleteBanner extends ConsumerWidget {
  CompleteBanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    StudyAid studyAid = watch(studyAidProvider);
    bool isCompleted = studyAid.isCompleted ?? false;
    return Container(
      alignment: Alignment.bottomLeft,
      color: isCompleted ? Colors.green[500] : Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isCompleted ? _completeBanner(watch) : _incompleteBanner(watch),
      ),
    );
  }

  Widget _completeBanner(ScopedReader watch) {
    final studyAidNotifier = watch(studyAidProvider.notifier);
    return GestureDetector(
      onTap: () => _toggle(studyAidNotifier),
      child: Center(
        child: Text(
          'Completed! 🎉',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  Widget _incompleteBanner(ScopedReader watch) {
    final studyAidNotifier = watch(studyAidProvider.notifier);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mark as completed',
          style: TextStyle(fontSize: 24),
        ),
        CupertinoSwitch(
          value: studyAidNotifier.isCompleted,
          onChanged: (value) => _toggle(studyAidNotifier),
        )
      ],
    );
  }

  void _toggle(StudyAidNotifier studyAidNotifier) {
    if (!studyAidNotifier.isCompleted) {
      studyAidNotifier.markCompleted();
    } else {
      studyAidNotifier.markIncompleted();
    }
  }
}

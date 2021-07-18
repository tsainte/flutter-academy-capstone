import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_academy_capstone/components/cheap_checkbox.dart';
import 'package:flutter_academy_capstone/components/nav_bar.dart';
import 'package:flutter_academy_capstone/components/progress.dart';
import 'package:flutter_academy_capstone/view/study/study_aid_view_model.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class StudyAidView extends StatelessWidget {
  StudyAidView(this._studyAidId, this._studyAidTitle, {Key? key})
      : super(key: key);
  final int _studyAidId;
  final String _studyAidTitle;
  late final StudyAidViewModel _viewModel =
      StudyAidViewModel(_studyAidId, _studyAidTitle);
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: FutureBuilder(
          future: _viewModel.getStudyAid(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                print('active');
                break;
              case ConnectionState.done:
                return _ContentStudyAid(_viewModel);
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
      navigationBar: NavBar.make(_viewModel.title),
    );
  }
}

class _ContentStudyAid extends StatelessWidget {
  _ContentStudyAid(
    this._viewModel, {
    Key? key,
  }) : super(key: key);

  final StudyAidViewModel _viewModel;

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
                _markdownWidget(_viewModel.content),
                _Checklist(_viewModel),
              ],
            ),
          ),
        ),
        _CompleteBanner(_viewModel),
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

  void openURL(String url) async {
    await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }
}

class _Checklist extends StatefulWidget {
  final StudyAidViewModel _viewModel;
  _Checklist(this._viewModel, {Key? key}) : super(key: key);

  @override
  __ChecklistState createState() => __ChecklistState();
}

class __ChecklistState extends State<_Checklist> {
  StudyAidViewModel? _viewModel;
  @override
  Widget build(BuildContext context) {
    _viewModel = widget._viewModel;
    return Container(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          _headerChecklist(),
          SizedBox(height: 16.0),
          for (int i = 0; i < _viewModel!.checklistCount; i++)
            _checklistItem(i),
        ]),
      ),
    );
  }

  Widget _headerChecklist() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Checklist',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(_viewModel!.checklistText()),
      ],
    );
  }

  Widget _checklistItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CheapCheckbox(
            _viewModel!.itemIsChecked(index),
            onChanged: (bool value) =>
                setState(() => _viewModel!.setIsChecked(index, value)),
          ),
          SizedBox(width: 8),
          Expanded(child: Text(_viewModel!.itemTitle(index))),
        ],
      ),
    );
  }
}

class _CompleteBanner extends StatefulWidget {
  final StudyAidViewModel viewModel;
  _CompleteBanner(this.viewModel, {Key? key}) : super(key: key);

  @override
  __CompleteBannerState createState() => __CompleteBannerState();
}

class __CompleteBannerState extends State<_CompleteBanner> {
  StudyAidViewModel? viewModel;
  bool _isComplete = false;

  @override
  Widget build(BuildContext context) {
    viewModel = widget.viewModel;
    return Container(
      alignment: Alignment.bottomLeft,
      color: _isComplete ? Colors.green[500] : Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isComplete ? _completeBanner() : _incompleteBanner(),
      ),
    );
  }

  Widget _completeBanner() {
    return GestureDetector(
      onTap: () => setState(_toggle),
      child: Center(
        child: Text(
          'Completed! 🎉',
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
    );
  }

  Widget _incompleteBanner() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Mark as completed',
          style: TextStyle(fontSize: 24),
        ),
        CupertinoSwitch(
          value: _isComplete,
          onChanged: (value) => setState(_toggle),
        )
      ],
    );
  }

  void _toggle() {
    if (!_isComplete) {
      viewModel!.markComplete();
    }
    _isComplete = !_isComplete;
  }
}

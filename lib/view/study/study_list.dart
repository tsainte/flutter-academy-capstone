import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_academy_capstone/components/nav_bar.dart';
import 'package:flutter_academy_capstone/components/progress.dart';
import 'package:flutter_academy_capstone/model/study_aid.dart';
import 'package:flutter_academy_capstone/view/study/study_aid_view.dart';
import 'study_list_view_model.dart';

class StudyList extends StatelessWidget {
  StudyList({Key? key}) : super(key: key);
  final viewModel = StudyListViewModel();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: NavBar.make('Flutter Academy 👩‍🎓'),
      child: _StudyListContent(viewModel),
    );
  }
}

class _StudyListContent extends StatelessWidget {
  const _StudyListContent(
    this.viewModel, {
    Key? key,
  }) : super(key: key);

  final StudyListViewModel viewModel;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: viewModel.getStudyAids(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.active:
            print('active');
            break;
          case ConnectionState.done:
            return _Content(viewModel: viewModel);
          case ConnectionState.none:
            print('none');
            break;
          case ConnectionState.waiting:
            return Progress();
        }
        return Text('Uknnown error');
      },
    );
    // return _Content(viewModel: viewModel);
  }
}

class _Content extends StatelessWidget {
  const _Content({
    Key? key,
    required this.viewModel,
  }) : super(key: key);

  final StudyListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // _HeaderList(),
        Expanded(
          child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
              color: Colors.black,
            ),
            itemCount: viewModel.studyAids.length,
            itemBuilder: (context, index) =>
                _StudyListCell(viewModel.studyAids[index]),
          ),
        ),
      ],
    );
  }
}

class _StudyListCell extends StatelessWidget {
  _StudyListCell(this._studyAid, {Key? key}) : super(key: key);
  final StudyAid _studyAid;

  @override
  Widget build(BuildContext context) {
    print(_studyAid.title);
    return GestureDetector(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _studyAid.title,
            style: TextStyle(fontSize: 24, color: Colors.amber),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(CupertinoPageRoute(
            builder: (context) => StudyAidView(_studyAid.id, _studyAid.title)));
      },
    );
  }
}

class _HeaderList extends StatelessWidget {
  const _HeaderList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Container(
        alignment: Alignment.topRight,
        color: CupertinoColors.inactiveGray,
        child: CupertinoButton(
            color: CupertinoColors.activeOrange,
            child: Text('push'),
            onPressed: () {}),
      ),
    );
  }
}

import 'package:yupcity_admin/models/CardInfo.dart';
import 'package:yupcity_admin/models/MyFiles.dart';
import 'package:yupcity_admin/responsive.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
  MyFiles(this.cardInfoList);

  List<CardInfo> cardInfoList;

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: defaultPadding),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            infoCardList: this.cardInfoList,
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(
            infoCardList: this.cardInfoList,
          ),
          desktop: FileInfoCardGridView(
            infoCardList: this.cardInfoList,
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatelessWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
    required this.infoCardList,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;
  final List<CardInfo> infoCardList;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: demoMyFiles.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(info: infoCardList[index]),
    );
  }
}

import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:spk_uptd/components/constants.dart';
import 'package:spk_uptd/controllers/AppControllers.dart';
import 'package:spk_uptd/models/MyFiles.dart';

class FileInfoCard extends StatelessWidget {
  const FileInfoCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final CloudStorageInfo info;

  @override
  Widget build(BuildContext context) {
    var myListProvider = Provider.of<AppControllers>(context, listen: false);
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(defaultPadding * 0.75),
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: info.color!.withOpacity(0.1),
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: SvgPicture.asset(
                  info.svgSrc!,
                  color: info.color,
                ),
              ),
              Icon(Icons.more_vert, color: Colors.white54)
            ],
          ),
          Text(
            info.title == "client"
                ? myListProvider.getisiTable.length.toString()
                : "",
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          ProgressLine(
            color: info.color,
            percentage: 0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                " Client",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white70),
              ),
              Text(
                "",
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: Colors.white),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class ProgressLine extends StatelessWidget {
  const ProgressLine({
    Key? key,
    this.color = primaryColor,
    required this.percentage,
  }) : super(key: key);

  final Color? color;
  final int? percentage;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 5,
          decoration: BoxDecoration(
            color: color!.withOpacity(0.1),
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
        ),
        LayoutBuilder(
          builder: (context, constraints) => Container(
            width: constraints.maxWidth * (percentage! / 100),
            height: 5,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}

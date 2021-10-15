
import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class SelectWeight extends StatelessWidget {
  final int index;
  final Function function;

  SelectWeight(this.index,this.function);

  @override
  Widget build(BuildContext context) {
    var weight = WeightOptional.values[index];
    double deviceWidth=MediaQuery.of(context).size.width;
    var enabled = (Globals.carSize.index < 2 && index < 2) ||
        (Globals.carSize.index == 2 && (index == 2 || index == 4)) ||
        (Globals.carSize.index == 3 && index == 3) ||
        (Globals.carSize.index == 4 && index == 4);
    return enabled ? Container(
      width: deviceWidth*0.4,
      child: Center(
        child: GestureDetector(
          onTap: () {
            if (enabled) {
              function(weight);
            }
          },
          child: Padding(
            padding: EdgeInsets.all(AppConfig.size(context, 3)),
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Globals.weight == weight
                            ? AppColors.main
                            : Colors.grey[200],
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        Globals.weightImages[weight.index],
                        // color: Globals.weight == weight ? Colors.blue : Colors.grey,
                        width: AppConfig.size(context, 28),
                        height: AppConfig.size(context, 28),
                      ),
                      Text(
                        Globals.weightTitles[weight.index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Globals.weight == weight
                                ? AppColors.main
                                : Colors.grey,
                            fontSize: AppConfig.size(context, 5)),
                      )
                    ],
                  ),
                ),
                if (!enabled)
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.withOpacity(0.5),
                        borderRadius: BorderRadius.all(Radius.circular(20))),
                  )
              ],
            ),
          ),
        ),
      ),
    ): Container();
    // });
    // return menu;
  }
}

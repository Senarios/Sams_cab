
import 'package:flutter/material.dart';
import 'package:sam_rider_app/src/util/globals.dart';
import 'package:sam_rider_app/src/util/utils.dart';

class CarSize extends StatefulWidget {
   final int index;
   final Function function;

  CarSize(this.index,this.function);

  @override
  _CarSizeState createState() => _CarSizeState();
}

class _CarSizeState extends State<CarSize> {
  @override
  Widget build(BuildContext context) {
    var car = CarSizeOptional.values[widget.index];
    double deviceWidth=MediaQuery.of(context).size.width;
    return Container(
      width: deviceWidth * 0.4,
      child: Center(
        child: GestureDetector(
          onTap: () {
            widget.function(car);
          },
          child: Padding(
              padding: EdgeInsets.all(AppConfig.size(context, 2)),
              child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(
                        color: Globals.carSize == car
                            ? AppColors.main
                            : Colors.grey[200],
                        width: 2,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Image.asset(
                          Globals.carImages[car.index],
                          // color: Globals.weight == weight ? Colors.blue : Colors.grey,
                          width: AppConfig.size(context, 30),
                          height: AppConfig.size(context, 30),
                        ),
                      ),
                      Text(
                        Globals.carNames[car.index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Globals.carSize == car
                                ? AppColors.main
                                : Colors.grey,
                            fontSize: AppConfig.size(context, 5)),
                      )
                    ],
                  ))),
        ),
      ),
    );
  }
}

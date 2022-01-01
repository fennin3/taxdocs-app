import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taxdocs/Provider/app_state.dart';
import 'package:taxdocs/constant.dart';


class SortWidget extends StatefulWidget {
  final Function(int) onTap;
  const SortWidget({
    Key? key,
    required this.onTap,
    required this.size,
  }) : super(key: key);

  final Size size;

  @override
  State<SortWidget> createState() => _SortWidgetState();
}

class _SortWidgetState extends State<SortWidget> {

  showBottomSheet(){
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))
        ),
        context: context, builder: (context){
      return  SortContainer(onTap: (filter){
        widget.onTap(filter);
      },);
    });
  }


  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: ()=> showBottomSheet(),
        child: FittedBox(child: Image.asset("assets/img/sort.png", width: widget.size.height < 900 ? 20 : 20, height: widget.size.height < 900 ? 20 : 20,)));
  }
}


class SortContainer extends StatefulWidget {
  final Function(int) onTap;
  const SortContainer({Key? key, required this.onTap}) : super(key: key);

  @override
  _SortContainerState createState() => _SortContainerState();
}

class _SortContainerState extends State<SortContainer> {

  String _radioKey = "1";

  @override
  Widget build(BuildContext context) {
    final app = Provider.of<appState>(context,listen: false);
    _radioKey = app.filter.toString();
    return Container(
      padding: const EdgeInsets.only(top: 28, left: 24, right: 24),
      height: 300,
      decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(24), topRight: Radius.circular(24))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Sort", style: textStyle.copyWith(fontSize: 18, color: blue),),
          const SizedBox(height: 17,),

          RadioListTile<String>(
          title: Text('By modified date', style: textStyle.copyWith(fontWeight: FontWeight.w500, color: blue),),
          value: '1',
          groupValue: _radioKey,
          onChanged: (String? value) {
            setState(() { _radioKey = value!; });
                widget.onTap(int.parse(_radioKey));
                app.setFilter(int.parse(value!));
          },
        ),
            const Divider(height: 1.3,),
        RadioListTile<String>(
          title: Text('By name  A - Z', style: textStyle.copyWith(fontWeight: FontWeight.w500, color: blue),),
          value: '2',
          groupValue: _radioKey,
          onChanged: (String? value) {
            setState(() { _radioKey = value!; });
                widget.onTap(int.parse(_radioKey));
                app.setFilter(int.parse(value!));
          },
        ),
        const Divider(height: 1.3,),

        RadioListTile<String>(
          title: Text('By name  Z - A', style: textStyle.copyWith(fontWeight: FontWeight.w500, color: blue),),
          value: '3',
          groupValue: _radioKey,
          onChanged: (String? value) {
            setState(() { _radioKey = value!; });
                widget.onTap(int.parse(_radioKey));
                app.setFilter(int.parse(value!));
          },
        ),

        ],
      ),
    );
  }
}

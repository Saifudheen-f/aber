import 'package:espoir_marketing/core/decoration.dart';
import 'package:flutter/material.dart';

class CustomerCard extends StatelessWidget {
  final Map<String, dynamic> customer;
  final String date;
  final String? task;
  final bool taskbutton;
  final VoidCallback? onpress;

  const CustomerCard(
      {required this.customer,
      Key? key,
      required this.date,
      this.task,
      this.taskbutton = false,
      this.onpress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 250, 250, 250),
              const Color.fromARGB(255, 247, 235, 235),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListTile(
          leading: _buildLeading(),
          title: _buildTitle(),
          subtitle: _buildSubtitle(),
          trailing: _buildTrailing(),
        ),
      ),
    );
  }

  Widget _buildLeading() {
    return Container(
      width: 40,
      height: 50,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: gradient,
      ),
      child: Center(
        child: Text(
          _getCustomerInitial(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      customer['Name'] ?? 'Unknown Name',
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
    );
  }

  Widget _buildSubtitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(date),
        task != null
            ? Text(
                task ?? "",
                style: TextStyle(color: Colors.red),
              )
            : SizedBox()
      ],
    );
  }

  Widget _buildTrailing() {
    if (taskbutton) {
      return GestureDetector(
        onTap: onpress ,
        child: Container(
          width: 80,
          decoration: BoxDecoration(
              color: const Color.fromARGB(255, 218, 217, 217),
              borderRadius: BorderRadius.circular(3)),
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add_task_outlined,
                  size: 16,
                  color: Colors.red,
                ),
                Text(
                  " Add task",
                  style: TextStyle(fontSize: 10),
                )
              ],
            ),
          ),
        ),
      );
      //return IconButton(onPressed:onpress, icon: Icon(Icons.add_task_sharp));
    }
    return const Icon(
      Icons.arrow_forward_ios,
      color: Color.fromARGB(255, 143, 140, 140),
      size: 20,
    );
  }

  String _getCustomerInitial() {
    return customer['Name']?.isNotEmpty ?? false
        ? customer['Name']![0].toUpperCase()
        : '?';
  }
}
